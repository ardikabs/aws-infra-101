resource "aws_ssm_parameter" "default" {
  for_each = var.use_parameter_store ? {
    "host"     = module.redis.replication_group_primary_endpoint_address
    "port"     = var.redis_port
    "password" = try(random_password.auth[0].result, "unset")
  } : {}

  name        = "/secrets/redis/${var.name}/${each.key}"
  description = "The ${each.key} attribute for ElastiCache Redis Instance ${var.name}"
  type        = "SecureString"
  value       = each.value

  tags = merge(
    local.common_tags,
    {
      "CredentialType" = "Access"
      "ResourceType"   = "ElastiCache/Redis"
      "ResourceName"   = var.name
      "ResourceARN"    = module.redis.replication_group_arn
      "Access"         = "View"
    }
  )
}

resource "aws_ssm_parameter" "additional_users" {
  for_each = var.use_parameter_store && var.create_usergroup ? { for key, value in local.users_with_password : key => "true" } : {}

  name        = "/secrets/redis/${var.name}/userpass/${each.key}"
  description = "The user credential (${each.key}) for ElastiCache Redis Instance ${var.name}"
  type        = "SecureString"
  value       = random_password.user_auth[each.key].result

  tags = merge(
    local.common_tags,
    {
      "CredentialType" = "CustomUserAccess"
      "ResourceType"   = "ElastiCache/Redis"
      "ResourceName"   = var.name
      "ResourceARN"    = module.redis.replication_group_arn
      "Access"         = "View"
    }
  )
}
