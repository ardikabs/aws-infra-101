variable "environment_name" {
  description = "(Required) Environment name the resource belongs to"
  type        = string
}

variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

variable "default_pull_accounts" {
  description = "(Optional) List of allowed AWS accounts to pull the registry"
  type        = list(string)
  default     = []
}

variable "repositories" {
  description = "(Required) A map of repositories to create with their allowed accounts"
  type = map(object({
    owner         = string
    team          = string
    immutable     = optional(bool)
    scan_on_push  = optional(bool)
    pull_accounts = optional(list(string))
    resources = map(object({
      owner = optional(string)
      team  = optional(string)
    }))
  }))
}

variable "additional_tags" {
  description = "(Optional, Default:{}) Additional tags for the ECS cluster"
  type        = map(string)
  default     = {}
}
