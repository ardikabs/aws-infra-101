terraform {
  source = "${get_repo_root()}/modules/network"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name      = "s-hkg-rdk-01"
  team_name = "infrastructure"

  cidr_block           = "10.250.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  use_single_nat  = true
  use_nat_gateway = false

  public_subnets = {
    "public-a" = {
      availability_zone = "ap-east-1a"
      cidr_block        = "10.250.0.0/22"
    }

    "public-b" = {
      availability_zone = "ap-east-1b"
      cidr_block        = "10.250.4.0/22"
      tier              = "public"
    }

    "public-c" = {
      availability_zone = "ap-east-1c"
      cidr_block        = "10.250.8.0/22"
      tier              = "public"
    }
  }

  public_subnets_additional_tags = {}

  private_subnets = {
    "data-a" = {
      availability_zone = "ap-east-1a"
      cidr_block        = "10.250.12.0/22"
      tier              = "data"
    }

    "data-b" = {
      availability_zone = "ap-east-1b"
      cidr_block        = "10.250.16.0/22"
      tier              = "data"
    }

    "data-c" = {
      availability_zone = "ap-east-1c"
      cidr_block        = "10.250.20.0/22"
      tier              = "data"
    }

    "workload-a" = {
      availability_zone  = "ap-east-1a"
      cidr_block         = "10.250.64.0/18"
      tier               = "workload"
      aws_private_access = true
    }

    "workload-b" = {
      availability_zone  = "ap-east-1b"
      cidr_block         = "10.250.128.0/18"
      tier               = "workload"
      aws_private_access = true
    }

    "workload-c" = {
      availability_zone  = "ap-east-1c"
      cidr_block         = "10.250.192.0/18"
      tier               = "workload"
      aws_private_access = true
    }
  }

  private_subnets_additional_tags = {}

  create_service_discovery  = true
  service_discovery_domains = ["svc.s-hkg-rdk-primary-ecs-01.local"]

  create_db_subnet_group = true
  db_subnet_group_tag_selector = {
    "Tier" = "data"
  }

  create_cache_subnet_group = true
  cache_subnet_group_tag_selector = {
    "Tier" = "data"
  }

  disable_nat_instance_stop_protection        = false
  disable_nat_instance_termination_protection = false
}