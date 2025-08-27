locals {
  users_with_password    = { for user, detail in var.users : user => detail if detail.require_password }
  users_with_no_password = { for user, detail in var.users : user => detail if !detail.require_password }
}

resource "random_password" "auth" {
  count            = var.generate_auth_password ? 1 : 0
  length           = 64
  override_special = "^&_+"
}

resource "random_password" "user_auth" {
  for_each         = local.users_with_password
  length           = 64
  override_special = "^&_+"
}

module "usergroup" {
  source  = "terraform-aws-modules/elasticache/aws//modules/user-group"
  version = "v1.2.0"

  count = var.create_usergroup ? 1 : 0

  user_group_id = "${var.name}-usergroup"

  create_default_user = true
  default_user = {
    user_id              = "${var.name}-uid"
    access_string        = "on ~* +@all"
    no_password_required = !var.generate_auth_password
    passwords            = try([random_password.auth[0].result], null)
  }

  users = merge(
    {
      for user, detail in local.users_with_password : user => {
        access_string = detail.access_string
        passwords     = [random_password.user_auth[user].result]
      }
    },
    {
      for user, detail in local.users_with_no_password : user => {
        access_string        = detail.access_string
        no_password_required = true
      }
    }
  )

  tags = merge(
    local.common_tags,
    {
      "ResourceType" = "ElastiCache/Redis"
      "ResourceName" = var.name
    }
  )
}
