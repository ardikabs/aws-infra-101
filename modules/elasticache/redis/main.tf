locals {
  supported_families = [
    { name = "redis2.8", prefix = "2.8" },
    { name = "redis3.2", prefix = "3.2" },
    { name = "redis4.0", prefix = "4.0" },
    { name = "redis5.0", prefix = "5.0" },
    { name = "redis6.x", prefix = "6." },
    { name = "redis7", prefix = "7." },
  ]

  family = [
    for f in local.supported_families :
    f.name
    if startswith(var.redis_version, f.prefix)
  ][0]
}

module "redis" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "v1.2.0"

  # Decision
  replication_group_id     = var.name
  create_cluster           = false
  create_replication_group = true
  description              = "ElastiCache Redis instance for ${var.name}"

  # Redis attributes
  engine                  = "redis"
  engine_version          = var.redis_version
  node_type               = var.instance_class
  num_cache_nodes         = 1
  num_cache_clusters      = 1
  num_node_groups         = null
  replicas_per_node_group = null

  # Redis access settings
  port                       = var.redis_port
  auth_token                 = var.create_usergroup ? null : try(random_password.auth[0].result, null)
  auth_token_update_strategy = "ROTATE"
  transit_encryption_enabled = true
  transit_encryption_mode    = "required"
  user_group_ids             = var.create_usergroup ? [module.usergroup[0].group_id] : null

  # Cluster settings
  multi_az_enabled           = false
  cluster_mode_enabled       = false
  automatic_failover_enabled = false

  # Connectivity settings
  create_subnet_group   = false
  create_security_group = false
  subnet_group_name     = var.cache_subnet_group_name
  security_group_ids    = concat(var.security_group_ids, try([module.security_group[0].security_group_id], []))

  # Backup settings
  snapshot_window           = null
  snapshot_name             = null
  snapshot_retention_limit  = 0 # If the value set to zero (0), backups are turned off
  final_snapshot_identifier = null

  # Operational settings
  maintenance_window = "sun:05:00-sun:09:00"
  apply_immediately  = true

  # Observability settings
  log_delivery_configuration = {}

  # log_delivery_configuration = {
  #   slow-log = {
  #     create_cloudwatch_log_group            = false
  #     cloudwatch_log_group_name              = "/redis/${var.name}/slow-log"
  #     cloudwatch_log_group_retention_in_days = 1
  #
  #     destination_type = "cloudwatch-logs"
  #     log_format       = "json"
  #   }
  # }

  # [WIP] Parameter Group
  create_parameter_group      = var.create_parameter_group
  parameter_group_name        = "${var.name}-parameters"
  parameter_group_family      = local.family
  parameter_group_description = "Parameter Group for ${var.name} ElastiCache Redis instance"
  parameters                  = var.parameters

  tags = local.common_tags
}
