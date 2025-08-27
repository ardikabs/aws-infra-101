#------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.vpc.id

  tags = merge(
    {
      Name = lower("${var.name}-${each.key}")
      Tier = coalesce(each.value.tier, "private")
    },
    local.common_tags,
    var.private_subnets_additional_tags
  )
}

#------------------------------------------------------------------------------
# Route Tables
#------------------------------------------------------------------------------

# Route table
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = lower("${var.name}-${each.key}-routetable")
    },
    local.common_tags,
  )
}

# Route to access internet
resource "aws_route" "private_internet_route" {
  for_each = aws_route_table.private

  destination_cidr_block = "0.0.0.0/0"

  route_table_id       = each.value.id
  nat_gateway_id       = var.use_nat_gateway ? (var.use_single_nat ? aws_nat_gateway.nat[local.single_nat_gateway_zone].id : aws_nat_gateway.nat[aws_subnet.private[each.key].availability_zone].id) : null
  network_interface_id = !var.use_nat_gateway ? (var.use_single_nat ? aws_instance.nat[local.single_nat_gateway_zone].primary_network_interface_id : aws_instance.nat[aws_subnet.private[each.key].availability_zone].primary_network_interface_id) : null
}

# Association of Route Table to Subnets
resource "aws_route_table_association" "private_internet_route" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
