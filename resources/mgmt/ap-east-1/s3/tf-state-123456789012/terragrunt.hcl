terraform {
  source = "${get_repo_root()}/modules/s3-bucket"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name         = "tf-state-123456789012"
  team_name    = "infrastructure"
  service_name = "infrastructure"

  inline_policy = file("${get_terragrunt_dir()}/policy.json")

  additional_tags = {
    Purpose = "Terraform Global State"
  }
}