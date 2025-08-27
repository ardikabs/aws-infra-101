provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

terraform {
  required_version = ">= 1.5"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.36.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
  }
}
