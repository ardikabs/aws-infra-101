terraform {
  source = "${get_repo_root()}/modules/s3-bucket"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name         = "shared-bucket-987654321098"
  service_name = "shared"
  team_name    = "shared"

  allowed_roles_to_read = []

  allowed_roles_to_edit = [
    "arn:aws:iam::987654321098:role/BackendRole",
  ]

  additional_tags = {
    Purpose = "Shared S3 bucket for staging environment"
  }

  enable_acl        = true
  enable_versioning = false
}