locals {
  is_require_aws_private_access_for_public_subnet  = length({ for key, value in var.public_subnets : key => "true" if coalesce(value.aws_private_access, false) }) == 0 ? false : true
  is_require_aws_private_access_for_private_subnet = length({ for key, value in var.private_subnets : key => "true" if coalesce(value.aws_private_access, false) }) == 0 ? false : true

  public_route_tables_with_private_access  = { for key, val in zipmap(keys(var.public_subnets), values(aws_route_table.public)) : key => val if coalesce(var.public_subnets[key].aws_private_access, false) }
  private_route_tables_with_private_access = { for key, val in zipmap(keys(var.private_subnets), values(aws_route_table.private)) : key => val if coalesce(var.private_subnets[key].aws_private_access, false) }
}

data "aws_vpc_endpoint_service" "aws" {
  for_each     = (local.is_require_aws_private_access_for_public_subnet || local.is_require_aws_private_access_for_private_subnet) ? toset(var.aws_private_access_services) : toset([])
  service      = each.key
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "aws" {
  for_each = data.aws_vpc_endpoint_service.aws

  vpc_id       = aws_vpc.vpc.id
  service_name = data.aws_vpc_endpoint_service.aws[each.key].service_name
}

resource "aws_vpc_endpoint_route_table_association" "public" {
  for_each = { for pair in setproduct(toset(var.aws_private_access_services), values(local.public_route_tables_with_private_access)) : "${pair[0]}::${pair[1].tags["Name"]}" => { vpc_endpoint_id = aws_vpc_endpoint.aws[pair[0]].id, route_table_id = pair[1].id } }

  vpc_endpoint_id = each.value.vpc_endpoint_id
  route_table_id  = each.value.route_table_id
}

resource "aws_vpc_endpoint_route_table_association" "private" {
  for_each = { for pair in setproduct(toset(var.aws_private_access_services), values(local.private_route_tables_with_private_access)) : "${pair[0]}::${pair[1].tags["Name"]}" => { vpc_endpoint_id = aws_vpc_endpoint.aws[pair[0]].id, route_table_id = pair[1].id } }

  vpc_endpoint_id = each.value.vpc_endpoint_id
  route_table_id  = each.value.route_table_id
}

resource "aws_ec2_instance_connect_endpoint" "eic" {
  for_each           = toset([keys(var.public_subnets)[0]])
  subnet_id          = aws_subnet.public[each.key].id
  security_group_ids = [aws_default_security_group.default.id]
  tags               = aws_subnet.public[each.key].tags
}
