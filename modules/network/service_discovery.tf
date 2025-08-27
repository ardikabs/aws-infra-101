#------------------------------------------------------------------------------
# AWS CloudMap (Service Discovery)
#------------------------------------------------------------------------------

resource "aws_service_discovery_private_dns_namespace" "default" {
  for_each = var.create_service_discovery ? toset(var.service_discovery_domains) : toset([])

  name        = each.key
  description = "Private DNS Namespace for service discovery on ${each.key}"
  vpc         = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    var.vpc_additional_tags,
  )
}
