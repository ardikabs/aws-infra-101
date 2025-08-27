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

variable "name" {
  description = "(Required) The ELB name"
  type        = string
}

variable "internal" {
  description = "(Optional, Default=true) If true, the ELB will be internal"
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "(Required) A map of ingress rules to apply to the NLB"
  type = map(object({
    alpn_policy = optional(string)

    port            = number
    protocol        = string
    target_port     = number
    target_protocol = optional(string)
    slow_start      = optional(number)

    certificate_arn = optional(string)
    certificate_selector = optional(object({
      domain = string
    }))
  }))
}

variable "enable_deletion_protection" {
  description = "(Optional, Default=false) If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "(Optional, Default=[]) A list of subnet IDs associated with the ECS service"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "(Optional, Default=false) If true, a security group will be created for the NLB"
  type        = bool
  default     = false
}

variable "security_group_ingress_rules" {
  description = "(Optional, Default=[]) List of ingress rules to apply to the security group"
  type = list(object({
    port        = number
    sources     = list(string)
    description = string
  }))
  default = []
}

variable "security_group_ids" {
  description = "(Optional, Default=[]) List of security group IDs to associate with this NLB instance"
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to all the resources."
  type        = map(string)
  default     = {}
}
