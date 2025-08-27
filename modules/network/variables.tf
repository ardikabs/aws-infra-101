#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------

variable "name" {
  description = "(Required) Name to be used on all the resources as identifier"
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

variable "aws_private_access_services" {
  description = "(Optional, Default=[s3,dynamodb]) A list of AWS services to enable private access to. This is a VPC feature that enables you to privately access specific AWS services from your VPC using private IP addresses. For more information, see https://docs.aws.amazon.com/vpc/latest/userguide/vpce-gateway.html#access-services."
  type        = list(string)
  default     = ["s3", "dynamodb"]
}

#------------------------------------------------------------------------------
# AWS Virtual Private Network (VPC)
#------------------------------------------------------------------------------
variable "cidr_block" {
  description = "(Optional, Default=null) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length"
  type        = string
  default     = null
}

variable "enable_dns_support" {
  description = "(Optional, Default=true) A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "(Optional, Default=false) Indicates whether Network Address Usage metrics are enabled for your VPC."
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "(Optional, Default=false) A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = false
}

variable "vpc_additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to the VPC resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------------------
variable "public_subnets" {
  description = "(Optional, Default={}) Map of objects contining the definition for each public subnet"
  type = map(object({
    availability_zone  = string           # Availability Zone for the subnet.
    cidr_block         = string           # The IPv4 CIDR block for the subnet.
    tier               = optional(string) # The tier of the subnet. It defaults to public.
    aws_private_access = optional(bool)   # Indicates whether instances in the subnet should have private access to AWS resources, such as Amazon S3. Default: false.
  }))
  default = {}
}

variable "public_subnets_additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "use_single_nat" {
  description = "(Optional, Default=false) Use single NAT Gateway"
  type        = bool
  default     = false
}

variable "use_nat_gateway" {
  description = "(Optional, Default=true) Whether to create NAT Gateways or not. If set to false, NAT Instances will be created instead."
  type        = bool
  default     = true
}

variable "disable_nat_instance_stop_protection" {
  description = "(Optional, Default=true) Disable stop protection for NAT Instances. Relevant only if use_nat_gateway is false."
  type        = bool
  default     = true
}

variable "disable_nat_instance_termination_protection" {
  description = "(Optional, Default=false) Disable termination protection for NAT Instances. Relevant only if use_nat_gateway is false."
  type        = bool
  default     = false
}

variable "single_nat_availability_zone" {
  description = "(Optional, Default=null) Availability Zone to be picked for the single NAT Gateway"
  type        = string
  default     = null
}

variable "secondary_nat_ips" {
  description = "(Optional, Default={}) Map of objects containing the definition for each secondary NAT IP based on availability zone. It mutually exclusive with secondary_nat_ip_counts."
  type = map(object({
    eip_ids = list(string) # List of Elastic IPs to be used for the secondary NAT Gateway
  }))
  default = {}
}

variable "secondary_nat_ip_counts" {
  description = "(Optional, Default=0) Number of secondary NAT IPs to be created. It mutually exclusive with secondary_nat_ips."
  type        = number
  default     = 0
}

#------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------
variable "private_subnets" {
  description = "(Optional, Default={}) Map of objects contining the definition for each private subnet"
  type = map(object({
    availability_zone  = string           # Availability Zone for the subnet.
    cidr_block         = string           # The IPv4 CIDR block for the subnet.
    tier               = optional(string) # The tier of the subnet. It defaults to private.
    aws_private_access = optional(bool)   # Indicates whether instances in the subnet should have private access to AWS resources, such as Amazon S3. Default: false.
  }))
  default = {}
}

variable "private_subnets_additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to the private subnet resources"
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# DB Subnet Group
#------------------------------------------------------------------------------

variable "create_db_subnet_group" {
  description = "(Optional, Default=false) Create a DB subnet group"
  type        = bool
  default     = false
}

variable "db_subnet_group_tag_selector" {
  description = "(Optional, Default={}) Map which consist of key value pair of tags to select the subnets for DB subnet group"
  type        = map(string)
  default = {
    "Tier" = "data"
  }
}

variable "db_subnet_group_additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to the DB subnet group"
  type        = map(string)
  default     = {}
}


#------------------------------------------------------------------------------
# Cache Subnet Group
#------------------------------------------------------------------------------

variable "create_cache_subnet_group" {
  description = "(Optional, Default=false) Create a Cache subnet group"
  type        = bool
  default     = false
}

variable "cache_subnet_group_tag_selector" {
  description = "(Optional, Default={}) Map which consist of key value pair of tags to select the subnets for Cache subnet group"
  type        = map(string)
  default = {
    "Tier" = "data"
  }
}

variable "cache_subnet_group_additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to the Cache subnet group"
  type        = map(string)
  default     = {}
}


#------------------------------------------------------------------------------
# Service Discovery
#------------------------------------------------------------------------------

variable "create_service_discovery" {
  description = "(Optional, Default=false) Create a private DNS namespace for the VPC"
  type        = bool
  default     = false
}

variable "service_discovery_domains" {
  description = "(Optional, Default=[]) List of service discovery domains to be created"
  type        = list(string)
  default     = []
}


#------------------------------------------------------------------------------
# Miscellaneous
#------------------------------------------------------------------------------

variable "additional_tags" {
  description = "(Optional, Default={}) A map of tags to assign to all the resources."
  type        = map(string)
  default     = {}
}
