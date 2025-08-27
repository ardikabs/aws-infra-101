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
# RDS Postgres variables
#------------------------------------------------------------------------------

variable "postgres_version" {
  description = "(Optional, Default=14) The version of PostgreSQL to use"
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "(Optional, Default=db.t3.micro) The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "name" {
  description = "(Required) The name of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "(Required) The name of the database to create when the DB instance is created"
  type        = string
}

variable "db_user" {
  description = "(Required) Username for the master DB user"
  type        = string
}

variable "db_port" {
  description = "(Optional, Default=5432) The port on which the database accepts connections"
  type        = number
  default     = 5432
}

variable "multi_az" {
  description = "(Optional, Default=false) Create a multi-AZ RDS instance"
  type        = bool
  default     = false
}

variable "enable_logger" {
  description = "(Optional, Default=false) Enable CloudWatch logs for the RDS instance"
  type        = bool
  default     = false
}

variable "log_types" {
  description = "(Optional, Default=[postgresql, upgrade]) List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values: alert, audit, error, general, listener, slowquery, trace, postgresql, upgrade"
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "log_retention_period" {
  description = "(Optional, Default=1) The days to retain log for"
  type        = number
  default     = 1
}

variable "backup_retention_period" {
  description = "(Optional, Default=1) The days to retain backups for"
  type        = number
  default     = 1
}

variable "skip_final_snapshot" {
  description = "(Optional, Default=true) Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "(Optional, Default=false) If the DB instance should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "(Optional, Default='') The name of the DB subnet group to associate with this RDS instance"
  type        = string
}

variable "security_group_ids" {
  description = "(Optional, Default=[]) List of security group IDs to associate with this RDS instance"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "(Optional) The name of the VPC"
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "(Optional, Default=false) Whether to create a new security group for the RDS instance"
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
  description = "(Optional, Default=false) Whether to use the default security group for the RDS instance"
  type        = bool
  default     = false
}

variable "generate_master_password" {
  description = "(Optional, Default=true) Whether to generate a master password for the RDS instance"
  type        = bool
  default     = true
}

variable "allocated_storage" {
  description = "(Optional, Default=5) The amount of storage in GB to allocate to the RDS instance"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "(Optional, Default=100) The upper limit to which RDS can automatically scale the storage in GB"
  type        = number
  default     = 100
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
