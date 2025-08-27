variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

variable "cloudflare_account_id" {
  description = "(Required) The Cloudflare account ID"
  type        = string
  default     = null
}

variable "cloudflare_api_token" {
  description = "(Required) The Cloudflare API token to use for authentication"
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_team_name" {
  description = "(Required) The Cloudflare Zero Trust Network Access team name"
  type        = string
}

variable "github_client_id" {
  description = "(Required) The GitHub OAuth client ID"
  type        = string
  default     = null
}

variable "github_client_secret" {
  description = "(Required) The GitHub OAuth client secret"
  type        = string
  default     = null
}

variable "github_org" {
  description = "(Required) The GitHub organization to allow access"
  type        = string
}

variable "github_teams" {
  description = "(Optional, Default=[]) List of GitHub teams to allow access"
  type        = list(string)
  default     = []
}

variable "client_settings" {
  description = "(Required) The client settings to apply"
  type = map(object({
    enabled              = optional(bool)
    description          = optional(string)
    matcher              = optional(string)
    priority             = optional(number)
    allowed_to_leave     = optional(bool)
    auto_connect         = optional(number)
    service_mode_v2_mode = optional(string) # The service mode. Available values: 1dot1, warp, proxy, posture_only, warp_tunnel_only. Defaults to warp.

    domains = list(object({
      description = optional(string)
      suffix      = string
      dns_server  = list(string)
    }))

    routes = list(object({
      description = optional(string)
      host        = optional(string)
      address     = optional(string)
    }))
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
    "api-token"            = "/secrets/cloudflare/api-token"
    "account-id"           = "/secrets/cloudflare/account-id"
    "github-client-id"     = "/secrets/cloudflare/github-client-id"
    "github-client-secret" = "/secrets/cloudflare/github-client-secret"
  }
}
