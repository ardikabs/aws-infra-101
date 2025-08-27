terraform {
  source = "${get_repo_root()}/modules/parameter-store-secret"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment_name = "mgmt"

  specs = {
    "cloudflare" = {
      restricted = true
    }
  }
}