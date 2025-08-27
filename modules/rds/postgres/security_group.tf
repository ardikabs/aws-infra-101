
locals {
  default_security_groups = var.use_default_security_group ? [
    {
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      description = "PostgreSQL access within VPC (default)"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    }
  ] : []
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment_name]
  }
}


module "security_group" {
  count = var.create_security_group ? 1 : 0

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.name}-rds-sg"
  description = "PostgreSQL security group for ${var.name}"
  vpc_id      = data.aws_vpc.selected.id

  ingress_with_cidr_blocks = concat(
    [
      for ingress in var.security_group_ingress_rules : {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "tcp"
        description = ingress.description
        cidr_blocks = join(",", ingress.sources)
      }
    ],
    local.default_security_groups
  )

  tags = merge(
    local.common_tags,
    {
      "ResourceType" = "RDS/PostgreSQL"
      "ResourceName" = var.name
    }
  )
}
