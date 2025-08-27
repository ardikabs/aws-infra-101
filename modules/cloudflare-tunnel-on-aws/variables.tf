# --------------------------------------
# Common
# --------------------------------------
variable "environment_name" {
  description = "(Required) Environment name the resource belongs to"
  type        = string
}

variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

# --------------------------------------
# Cloudflare Tunnel
# --------------------------------------
variable "cloudflare_account_id" {
  description = "(Required) The Cloudflare account ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_api_token" {
  description = "(Required) The Cloudflare API token to use for authentication."
  type        = string
  sensitive   = true
  default     = null
}

variable "tunnel_name" {
  description = "(Required) The name of the Cloudflare tunnel"
  type        = string
}

variable "tunnel_secret" {
  description = "(Optional) The secret password of the Cloudflare tunnel, if it is not provided, it will be generated automatically, and stored in AWS SSM Parameter Store if create_ecs_deployment enabled"
  type        = string
  default     = null
  sensitive   = true
}

variable "virtual_networks" {
  description = "(Required) A map of virtual networks to create for the Cloudflare tunnel (L3 section)"
  type = map(object({
    routes = list(object({
      network     = string
      description = optional(string)
    }))
    description = string
    default     = optional(bool)
  }))
}

# --------------------------------------
# AWS Metadata
# --------------------------------------
variable "aws_account_id" {
  description = "(Optional) The AWS account ID"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "(Optional) The AWS region"
  type        = string
  default     = "ap-east-1"
}

variable "use_parameter_store" {
  description = "(Optional) Whether to fetch necessary secrets from AWS SSM Parameter Store or not"
  type        = bool
  default     = false
}

variable "parameter_store_prefix_map" {
  description = "(Optional) The prefix to use for fetching secrets from AWS SSM Parameter Store"
  type        = map(string)
  default = {
    "api-token"  = "/secrets/cloudflare/api-token"
    "account-id" = "/secrets/cloudflare/account-id"
  }
}

variable "store_token_on_parameter_store" {
  description = "(Optional) Whether to store the Cloudflare tunnel secret on AWS SSM Parameter Store or not"
  type        = bool
  default     = false
}

variable "token_prefix_name" {
  description = "(Optional) The prefix to use for storing the Cloudflare tunnel secret on AWS SSM Parameter Store"
  type        = string
  default     = "/secrets/cloudflared"
}

# --------------------------------------
# AWS ECS Deployment
# --------------------------------------
variable "create_ecs_deployment" {
  description = "(Optional) Whether to create ECS deployment or not"
  type        = bool
  default     = false
}

variable "ecs_service_name" {
  description = "(Optional) The ECS service name"
  type        = string
  default     = null
}

variable "ecs_deployment_manifest" {
  description = "(Optional) The path to the ECS deployment manifest file (YAML)"
  type        = string
  default     = null
}
