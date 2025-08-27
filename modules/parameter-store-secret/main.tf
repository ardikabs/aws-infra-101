locals {
  common_tags = merge({
    "ManagedBy" = "terraform"
    "Entity"    = var.entity_name
    },
    var.additional_tags,
  )

  loaded_specs = {
    for name, spec in var.specs :
    name => {
      prefix     = spec.prefix == null ? "" : spec.prefix
      restricted = spec.restricted == null ? false : spec.restricted
      tags       = spec.tags == null ? {} : spec.tags
      yaml       = yamldecode(file(format("%s/%s.yaml", path.cwd, name)))
    }
  }

  loaded_parameters_in_specs = {
    for svc, spec in local.loaded_specs :
    svc => [
      for name, param in spec.yaml.parameters : {
        name            = name
        prefix          = try(param.prefix, spec.prefix)
        team            = try(param.team, spec.yaml.team)
        tier            = try(param.tier, null)
        type            = try(param.type, null)
        allowed_pattern = try(param.allowed_pattern, null)
        description     = try(param.description, null)
        restricted      = try(param.restricted, spec.restricted)
        tags            = try(param.tags, spec.tags)
      }
    ]
  }

  parameters = flatten([
    for svc, params in merge(var.parameters, local.loaded_parameters_in_specs) : [
      for param in params : {
        id              = "${svc}/${param.name}"
        svc             = svc
        prefix_name     = param.prefix == "" ? svc : "${param.prefix}/${svc}"
        suffix_name     = param.name
        team            = param.team
        tier            = param.tier
        type            = param.type
        allowed_pattern = param.allowed_pattern
        description     = param.description
        restricted      = param.restricted
        tags            = param.tags
      }
    ]
  ])
}

resource "aws_ssm_parameter" "this" {
  for_each = { for parameter in local.parameters : parameter.id => parameter }

  name        = "/secrets/${each.value.prefix_name}/${each.value.suffix_name}"
  description = each.value.description == null ? "Created by Terraform" : each.value.description

  key_id          = var.kms_key_id
  type            = each.value.tier == null ? "SecureString" : each.value.type
  tier            = each.value.tier == null ? "Standard" : each.value.tier
  allowed_pattern = each.value.allowed_pattern == null ? ".*" : each.value.allowed_pattern
  value           = "unset"

  lifecycle {
    ignore_changes = [value]
  }

  tags = merge(
    local.common_tags,
    {
      "ServiceName" = each.value.svc
      "Team"        = each.value.team
      "Environment" = var.environment_name
      "Access"      = each.value.restricted ? "Restricted" : "Open"
    },
    each.value.tags
  )
}
