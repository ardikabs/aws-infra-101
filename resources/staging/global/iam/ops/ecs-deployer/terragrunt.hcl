terraform {
  source = "${get_repo_root()}/modules/iam/service"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  role_name        = "ECSDeployer"
  role_description = "It is for ECS service deployment"
  trusted_role_arns = [
    "arn:aws:iam::123456789012:role/GitHubActionConnectorRole",
    "arn:aws:iam::123456789012:user/operator",
  ]
  policy = file("${get_terragrunt_dir()}/policy.json")
}