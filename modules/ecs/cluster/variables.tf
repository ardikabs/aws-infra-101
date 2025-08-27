variable "name" {
  description = "(Required) Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)."
  type        = string
}

variable "environment_name" {
  description = "(Required) Environment name the resource belongs to"
  type        = string
}

variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

variable "team_name" {
  description = "(Optional, Default:infrastructure) Team name the resource belongs to"
  type        = string
  default     = "infrastructure"
}

variable "tier" {
  description = "(Optional, Default:primary) The tier ECS cluster belongs to. It has to be one of the following values: primary, secondary, or tertiary."
  type        = string
  default     = "primary"

  validation {
    condition     = contains(["primary", "secondary", "tertiary"], var.tier)
    error_message = "Tier must be one of the following values: primary, secondary, or tertiary."
  }
}

variable "additional_tags" {
  description = "(Optional, Default:{}) Additional tags for the ECS cluster"
  type        = map(string)
  default     = {}
}

variable "containerInsights" {
  description = "(Optional, Default:false) Enables container insights if true"
  type        = bool
  default     = false
}

