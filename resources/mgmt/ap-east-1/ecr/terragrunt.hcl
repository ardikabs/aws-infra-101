terraform {
  source = "${get_repo_root()}/modules/ecr"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  default_pull_accounts = [
    "123456789012", # mgmt
    "987654321098", # staging
  ]

  repositories = {
    "default" = {
      owner = "infrastructure@ardikabs.com"
      team  = "infrastructure"

      immutable     = true
      scan_on_push  = true
      pull_accounts = []

      resources = {
        "echoserver" = {}
      }
    }

    "backend" = {
      owner = "engineering@ardikabs.com"
      team  = "infrastructure"

      immutable     = true
      scan_on_push  = true
      pull_accounts = []

      resources = {
        gateway = {}
        monolith-core = {
          team = "core"
        }
        userprofile = {
          team = "userprofile"
        }
        trx-engine = {
          team = "trx"
        }
      }
    }
  }
}