terraform {
  source = "${get_repo_root()}/modules/elasticache/redis"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  team_name = "backend"

  name                   = "monolith-core"
  instance_class         = "cache.t3.micro"
  redis_version          = "7.1"
  generate_auth_password = true

  cache_subnet_group_name = "s-hkg-rdk-01-cache-subnet-group"

  create_security_group      = true
  use_default_security_group = true

  use_parameter_store = true
}