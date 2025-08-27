resource "aws_ssm_parameter" "secret" {
  for_each = var.use_parameter_store ? {
    "host"     = module.db.db_instance_address
    "user"     = module.db.db_instance_username
    "name"     = module.db.db_instance_name
    "port"     = module.db.db_instance_port
    "password" = try(random_password.master_password[0].result, "unset")
  } : {}

  name        = "/secrets/postgres/${var.name}/${each.key}"
  description = "The ${each.key} attribute for RDS PostgreSQL Instance ${var.name}"
  type        = "SecureString"
  value       = each.value

  tags = merge(
    local.common_tags,
    {
      "CredentialType" = "Access"
      "ResourceType"   = "RDS/Postgres"
      "ResourceName"   = var.name
      "ResourceARN"    = module.db.db_instance_arn
      "Access"         = "View"
    }
  )
}
