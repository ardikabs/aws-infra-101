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

resource "aws_ecs_cluster" "cluster" {
  name = var.name
  tags = local.common_tags

  dynamic "setting" {
    for_each = var.containerInsights == true ? [1] : []
    content {
      name  = "containerInsights"
      value = "enabled"
    }
  }
}
