terraform {
  source = "${get_repo_root()}/modules/rds/postgres"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  team_name = "core"

  name                     = "monolith-core"
  db_name                  = "monolith-core"
  db_user                  = "backend"
  generate_master_password = true

  postgres_version    = 14
  instance_class      = "db.t3.micro"
  allocated_storage   = 5 # in GB
  deletion_protection = false

  db_subnet_group_name = "s-hkg-rdk-01-db-subnet-group"

  create_security_group      = true
  use_default_security_group = true

  use_parameter_store = true
}