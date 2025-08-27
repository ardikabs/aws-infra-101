locals {
  common_tags = merge({
    "ManagedBy"   = "terraform"
    "Environment" = var.environment_name
    "Entity"      = var.entity_name
    "Team"        = var.team_name
    },
    var.additional_tags,
  )

  api_token  = try(data.aws_ssm_parameter.cloudflare["api-token"].value, var.cloudflare_api_token)
  account_id = try(data.aws_ssm_parameter.cloudflare["account-id"].value, var.cloudflare_account_id)
}

data "aws_ssm_parameter" "cloudflare" {
  for_each = var.use_parameter_store ? var.parameter_store_prefix_map : {}

  name = each.value
}
