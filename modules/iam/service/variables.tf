#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------

variable "role_name" {
  description = "(Required) IAM Role name"
  type        = string
}

variable "role_description" {
  description = "(Required) IAM Role description"
  type        = string
}

variable "trusted_role_arns" {
  description = "(Optional, Default:[]) List of ARNs of trusted entities"
  type        = list(string)
  default     = []
}

# Reference: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-services
variable "trusted_aws_services" {
  description = "(Optional, Default:[]) List of AWS services that can assume the role. For examples: ecs.amazonaws.com, ec2.amazonaws.com, ecs-task.amazonaws.com, spot.amazonaws.com, etc."
  type        = list(string)
  default     = []
}

variable "policy_arns" {
  description = "(Optional, Default:[]) List of ARNs of managed policies"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "(Optional, Default:'') The IAM Policy content in the form of JSON formatted string"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# Miscellaneous
#------------------------------------------------------------------------------

variable "additional_tags" {
  description = "(Optional, Default:{}) A map of tags to assign to all the resources."
  type        = map(string)
  default     = {}
}
