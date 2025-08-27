variable "name" {
  description = "(Required) The name of the S3 bucket"
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
  description = "(Required) Team name the resource belongs to"
  type        = string
}

variable "service_name" {
  description = "(Optional, Default:null) Team name the resource belongs to"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "(Optional, Default:true) Enable versioning for object in the S3 bucket"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "(Optional, Default:{}) Additional tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "allowed_roles_to_read" {
  description = "(Optional, Default:[]) List of IAM role ARNs that are allowed to read objects from the S3 bucket"
  type        = list(string)
  default     = []
}

variable "allowed_roles_to_edit" {
  description = "(Optional, Default:[]) List of IAM role ARNs that are allowed to edit objects from the S3 bucket"
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "(Optional, Default:null) Inline policy document in JSON format"
  type        = string
  default     = null
}

variable "enable_acl" {
  description = "(Optional, Default:false) Enable ACLs for the S3 bucket"
  type        = bool
  default     = false
}
