terraform {
  source = "${get_repo_root()}/modules/cloudflare-tunnel-on-aws"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  use_parameter_store = true
  tunnel_name         = "staging"
  virtual_networks = {
    "s-hkg-rdk-01" = {
      default     = false
      description = "Virtual network for s-hkg-rdk-01 VPC"
      routes = [
        {
          network     = "10.250.0.0/16"
          description = "Full connectivity to staging VPC"
        },
        {
          network     = "43.199.104.158/32"
          description = "Route to stg.ardikabs.com"
        },
        {
          network     = "18.167.226.65/32"
          description = "Route to stg.ardikabs.com"
        },
        {
          network     = "18.167.254.123/32"
          description = "Route to stg.ardikabs.com"
        }
      ]
    }
  }

  store_token_on_parameter_store = true
  token_prefix_name              = "/secrets/cloudflared"
}