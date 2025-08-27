terraform {
  source = "${get_repo_root()}/modules/parameter-store-secret"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment_name = "staging"

  specs = {
    "common" = {}
    "cloudflare" = {
      restricted = true
    }
    "echoserver"        = {}
    "monolith-core" = {}
    "gateway" = {
      restricted = true
    }
  }
}