#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# ElastiCache Redis variables
#------------------------------------------------------------------------------

variable "instance_class" {
  description = "(Optional, Default=cache.t3.micro) The instance type of the ElastiCache instance"
  type        = string
  default     = "cache.t3.micro"
}

variable "name" {
  description = "(Required) The name of the ElastiCache instance"
  type        = string
}

variable "redis_version" {
  description = "(Optional, Default=7.1) The version of Redis to use"
  type        = string
  default     = "7.1"
}

variable "redis_port" {
  description = "(Optional, Default=6379) The port on which the database accepts connections"
  type        = number
  default     = 6379
}

variable "cache_subnet_group_name" {
  description = "(Optional, Default='') The name of the cache subnet group to associate with this ElastiCache instance"
  type        = string
}

variable "security_group_ids" {
  description = "(Optional, Default=[]) List of security group IDs to associate with this ElastiCache instance"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "(Optional) The name of the VPC"
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "(Optional, Default=false) Whether to create a new security group for the ElastiCache instance"
  type        = bool
  default     = false
}

variable "security_group_ingress_rules" {
  description = "(Optional, Default=[]) List of ingress rules to apply to the security group"
  type = list(object({
    sources     = list(string)
    description = string
  }))
  default = []
}

variable "use_default_security_group" {
  description = "(Optional, Default=false) Whether to use the default security group for the ElastiCache instance"
  type        = bool
  default     = false
}

variable "generate_auth_password" {
  description = "(Optional, Default=true) Whether to generate an auth password to the ElastiCache instance"
  type        = bool
  default     = true
}

variable "users" {
  description = "(Optional, Default=[]) List of user groups to associate with this ElastiCache instance"
  type = map(object({
    access_string    = optional(string)
    require_password = bool
  }))
  default = {}
}

variable "create_usergroup" {
  description = "(Optional, Default=false) Whether to create a new user group for the ElastiCache instance"
  type        = bool
  default     = false
}

variable "transit_encryption_enabled" {
  description = "(Optional, Default=false) Whether to enable in-transit encryption for the ElastiCache instance"
  type        = bool
  default     = false
}

variable "transit_encryption_mode" {
  description = "(Optional, Default=preferred) A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required"
  type        = string
  default     = "preferred"
}

# --------------------------------------
# ElastiCache Parameter Group
# --------------------------------------
variable "create_parameter_group" {
  description = "(Optional, Default=false) Whether to create a new parameter group for the ElastiCache instance"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "(Optional, Default=[]) List of parameters to apply to the parameter group"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]
}

# --------------------------------------
# AWS Metadata
# --------------------------------------
variable "use_parameter_store" {
  description = "(Optional, Default=false) Whether to store the credential attributes of Postgres instance into AWS SSM Parameter Store"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Miscellaneous
#------------------------------------------------------------------------------

variable "additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to all the resources."
  type        = map(string)
  default     = {}
}
