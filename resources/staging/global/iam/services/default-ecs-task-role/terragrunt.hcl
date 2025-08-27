terraform {
  source = "${get_repo_root()}/modules/iam/service"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  role_name        = "DefaultECSTaskRole"
  role_description = "Default ECS Task Role."

  trusted_aws_services = ["ecs-tasks.amazonaws.com"]

  policy_arns = []

  policy = file("${get_terragrunt_dir()}/policy.json")
}