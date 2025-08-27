variable "entity_name" {
  description = "(Required) Entity name the resource belongs to"
  type        = string
}

variable "environment_name" {
  description = "(Required) Environment name the resource belongs to"
  type        = string
}

variable "kms_key_id" {
  description = "(Optional) The KMS key id or arn to use for the parameter"
  type        = string
  default     = null
}

variable "parameters" {
  description = "(Optional, Default:{}) A map of parameter definitions"
  type = map(object({
    team            = string
    prefix          = optional(string)
    tier            = optional(string)
    type            = optional(string)
    allowed_pattern = optional(string)
    description     = optional(string)
    restricted      = optional(bool)
    tags            = optional(map(string))
  }))

  default = {}
}

variable "specs" {
  description = "(Optional, Default:{}) A map of local YAML specification to be loaded, the content must follow the parameters variable data type"
  type = map(object({
    prefix     = optional(string)
    restricted = optional(bool)
    tags       = optional(map(string))
  }))
}

variable "additional_tags" {
  description = "(Optional, Default:{}) Additional tags for the parameter"
  type        = map(string)
  default     = {}
}
