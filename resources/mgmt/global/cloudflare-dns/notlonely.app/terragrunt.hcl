terraform {
  source = "${get_repo_root()}/modules/cloudflare-records"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  tld              = "ardikabs.com"
  environment_name = "staging"

  records = {
    "stg" = {
      value = "stg-ardikabs-com-7070379b2f740f76.elb.ap-east-1.amazonaws.com"
      type  = "CNAME"
      ttl   = 60

      tags = {
        Purpose = "staging"
      }
    }

    "api.stg" = {
      value = "stg.ardikabs.com"
      type  = "CNAME"
      ttl   = 60

      tags = {
        Purpose = "api"
      }
    }
  }

  use_parameter_store = true
}