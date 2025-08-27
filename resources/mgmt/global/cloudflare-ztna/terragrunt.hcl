terraform {
  source = "${get_repo_root()}/modules/cloudflare-ztna"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  use_parameter_store  = true
  cloudflare_team_name = "backend"
  github_org           = "ardikabs.com"
  github_teams         = ["backend-team"]
  client_settings = {
    "Default" = {
      allowed_to_leave     = true
      service_mode_v2_mode = "warp"

      domains = [
        {
          suffix     = "svc.s-hkg-rdk-primary-ecs-01.local"
          dns_server = ["10.250.0.2"]
        }
      ]

      routes = [
        {
          description = "Full connectivity to staging VPC"
          address     = "10.250.0.0/16"
        },
        {
          description = "Allow API Staging"
          host        = "api.stg.ardikabs.com"
        }
      ]
    }
  }
}