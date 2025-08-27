variable "environment_name" {
  description = "(Required) Environment name the resource belongs to"
  type        = string
}

variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

variable "team_name" {
  description = "(Required) Team name the resource belongs to"
  type        = string
}

variable "domain" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

# --------------------------------------
# Cloudflare Metadata
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

variable "additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to all the resources."
  type        = map(string)
  default     = {}
}
