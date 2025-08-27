terraform {
  source = "${get_repo_root()}/modules/acm-with-cloudflare"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  team_name = "infrastructure"

  domain                    = "*.stg.ardikabs.com"
  subject_alternative_names = ["stg.ardikabs.com"]
  additional_tags = {
    Purpose = "Wildcard certificate for staging environment"
  }

  use_parameter_store = true
}