resource "random_password" "master_password" {
  count            = var.generate_master_password ? 1 : 0
  length           = 64
  override_special = "^&_+"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  # PostgreSQL attributes
  identifier           = var.name
  engine               = "postgres"
  engine_version       = var.postgres_version
  family               = "postgres${var.postgres_version}"
  major_engine_version = var.postgres_version
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.db_user
  port     = var.db_port

  manage_master_user_password = false
  password                    = try(random_password.master_password[0].result, null)

  # Connectivity settings
  multi_az               = var.multi_az
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = concat(var.security_group_ids, try([module.security_group[0].security_group_id], []))

  # Backup settings
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  # Operational settings
  maintenance_window                     = "Mon:00:00-Mon:03:00"
  backup_window                          = "03:00-06:00"
  create_cloudwatch_log_group            = var.enable_logger
  enabled_cloudwatch_logs_exports        = var.log_types
  cloudwatch_log_group_retention_in_days = var.log_retention_period

  performance_insights_enabled          = false
  performance_insights_retention_period = 1

  # Observability settings
  create_monitoring_role          = false
  monitoring_interval             = 0
  monitoring_role_name            = "unset"
  monitoring_role_use_name_prefix = true
  monitoring_role_description     = "Monitoring Role for ${var.name} RDS PostgreSQL instance"

  # [WIP] Parameter Group
  create_db_parameter_group       = false
  parameter_group_name            = null # "${var.name}-parameters"
  parameter_group_description     = "Parameter Group for ${var.name} RDS PostgreSQL instance"
  parameter_group_use_name_prefix = true
  parameters                      = []
  # parameters = [
  #   {
  #     name  = "autovacuum"
  #     value = 1
  #   },
  #   {
  #     name  = "client_encoding"
  #     value = "utf8"
  #   }
  # ]

  tags = local.common_tags
}
