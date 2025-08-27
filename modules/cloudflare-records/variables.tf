variable "environment_name" {
  description = "(Required) The environment name"
  type        = string
}

variable "entity_name" {
  description = "(Required) The entity name"
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

variable "tld" {
  description = "(Required) The top-level domain name used to select the zone"
  type        = string
}

variable "records" {
  description = "(Required) A map of records to create"
  type = map(object({
    value   = string
    type    = string
    ttl     = optional(number)
    proxied = optional(bool)
    tags    = optional(map(string))
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
