resource "aws_ssm_parameter" "token" {
  count = var.store_token_on_parameter_store && !var.create_ecs_deployment ? 1 : 0

  name        = "${var.token_prefix_name}/${var.tunnel_name}/token"
  description = "The parameter of Tunnel secret for ${var.tunnel_name} tunnel"
  type        = "SecureString"
  value       = cloudflare_tunnel.tunnel.tunnel_token

  tags = {
    "ManagedBy"   = "terraform"
    "ServiceName" = try(local.manifest.metadata.name, "cloudflared")
    "Entity"      = var.entity_name
    "Environment" = var.environment_name
    "Team"        = try(local.manifest.metadata.team, "infrastructure")
    "Access"      = "Restricted"
  }
}
