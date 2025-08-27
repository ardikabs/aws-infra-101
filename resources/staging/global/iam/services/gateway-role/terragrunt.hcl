terraform {
  source = "${get_repo_root()}/modules/iam/service"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  role_name        = "GatewayRole"
  role_description = "IAM Role for api gateway service"

  trusted_aws_services = ["ecs-tasks.amazonaws.com"]

  policy_arns = []

  policy = file("${get_terragrunt_dir()}/policy.json")
}