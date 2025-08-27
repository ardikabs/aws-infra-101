#------------------------------------------------------------------------------
# AWS Virtual Private Network (VPC)
#------------------------------------------------------------------------------

# VPC
resource "aws_vpc" "vpc" {
  # IPv4
  cidr_block = var.cidr_block

  # Settings
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames

  # Tags
  tags = merge(
    {
      "Name" = var.name
    },
    local.common_tags,
    var.vpc_additional_tags,
  )
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.name}-default-sg"
    },
    local.common_tags,
  )
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = merge(
    {
      "Name" = "${var.name}-default-routetable"
    },
    local.common_tags,
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id
}
