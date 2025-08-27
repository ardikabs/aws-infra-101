locals {
  manifest = try(yamldecode(file(var.ecs_deployment_manifest)), {})
}

module "ecs_deployment" {
  count      = var.create_ecs_deployment ? 1 : 0
  depends_on = [cloudflare_tunnel.tunnel, aws_ssm_parameter.ecs_parameters]
  source     = "git::https://github.com/hatchery-corp/terraform-aws-ecs-deployment.git//modules/deployment-on-terragrunt?ref=latest"

  default_definition  = "[]"
  service_name        = var.ecs_service_name
  manifest_definition = file(var.ecs_deployment_manifest)
  working_directory   = dirname(var.ecs_deployment_manifest)
}

resource "aws_ssm_parameter" "ecs_parameters" {
  count = var.create_ecs_deployment && !var.store_token_on_parameter_store ? 1 : 0

  name        = "/secrets/${coalesce(var.ecs_service_name, "cloudflared")}/${var.tunnel_name}/token"
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
