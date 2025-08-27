terraform {
  source = "${get_repo_root()}/modules/nlb"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name      = "stg.ardikabs.com"
  team_name = "infrastructure"
  internal  = false

  ingress_rules = {
    "http" = {
      port            = 80
      protocol        = "TCP"
      target_port     = 9000
      target_protocol = "TCP"
    }

    "https" = {
      alpn_policy     = "HTTP2Preferred"
      port            = 443
      protocol        = "TLS"
      target_port     = 10080
      target_protocol = "TCP"

      certificate_selector = {
        domain = "*.stg.ardikabs.com"
      }
    }
  }

  create_security_group = true
  security_group_ingress_rules = [
    {
      port        = 80
      sources     = ["0.0.0.0/0"]
      description = "Allow Traffic from the Internet"
    },
    {
      port        = 443
      sources     = ["0.0.0.0/0"]
      description = "Allow Traffic from the Internet"
    },
  ]
}