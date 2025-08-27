terraform {
  source = "${get_repo_root()}/modules/s3-bucket"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name         = "ecs-configs-123456789012"
  team_name    = "infrastructure"
  service_name = "infrastructure"

  allowed_roles_to_read = [
    "arn:aws:iam::987654321098:role/DefaultECSExecutionRole",
  ]

  allowed_roles_to_edit = [
    "arn:aws:iam::987654321098:role/ECSDeployer",
  ]

  additional_tags = {
    Purpose = "ECS Configs"
  }
}