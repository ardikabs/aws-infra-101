
module "security_group" {
  count   = var.create_security_group ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.name}-nlb-sg"
  description = "Security Group for NLB ${var.name}"
  vpc_id      = data.aws_vpc.selected.id

  ingress_with_cidr_blocks = flatten([
    for ingress in var.security_group_ingress_rules : [
      for source in ingress.sources : {
        cidr_blocks = source
        from_port   = ingress.port
        to_port     = ingress.port
        protocol    = "tcp"
        description = ingress.description
      }
    ]
  ])

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all traffic to leave the security group"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = merge(
    local.common_tags,
    {
      "ResourceType" = "NLB"
      "ResourceName" = var.name
    }
  )
}
