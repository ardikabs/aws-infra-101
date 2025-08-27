locals {
  common_tags = merge({
    "ManagedBy"   = "terraform"
    "Environment" = var.environment_name
    "Entity"      = var.entity_name
    "Team"        = var.team_name
    },
    var.additional_tags,
  )
}
