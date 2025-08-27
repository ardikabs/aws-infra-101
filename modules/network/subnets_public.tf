locals {
  single_nat_gateway_zone = coalesce(var.single_nat_availability_zone, aws_subnet.public[keys(aws_subnet.public)[0]].availability_zone)

  nat_meta = var.use_single_nat ? { for s in aws_subnet.public : s.availability_zone => s if s.availability_zone == local.single_nat_gateway_zone } : { for s in aws_subnet.public : s.availability_zone => s }

  # [Work In Progress] possible a bug because of the provider, specifically in aws_nat_gateway resource
  # nat_secondary_meta = var.use_single_nat ? { for idx in range(var.secondary_nat_ip_counts) : "${local.single_nat_gateway_zone}_${idx}" => "SECONDARY" } : { for pair in setproduct(keys(local.nat_meta), range(var.secondary_nat_ip_counts)) : "${pair[0]}_${pair[1]}" => "SECONDARY" }
}

#------------------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.vpc.id

  tags = merge(
    {
      Name = lower("${var.name}-${each.key}")
      Tier = coalesce(each.value.tier, "public")
    },
    local.common_tags,
    var.public_subnets_additional_tags
  )
}

#------------------------------------------------------------------------------
# NAT
#------------------------------------------------------------------------------

# Elastic IPs for NAT
resource "aws_eip" "nat" {
  for_each = local.nat_meta

  domain = "vpc"

  instance = !var.use_nat_gateway ? aws_instance.nat[each.key].id : null

  tags = merge(
    {
      Name = lower("${each.value.tags["Name"]}-nat-eip")
    },
    local.common_tags,
  )
}

# [Work In Progress] possible a bug because of the provider, specifically in aws_nat_gateway resource
# resource "aws_eip" "nat_secondary" {
#   for_each = var.secondary_nat_ip_counts == 0 ? {} : (length(var.secondary_nat_ips) > 0 ? {} : local.nat_secondary_meta)

#   domain = "vpc"

#   tags = merge(
#     {
#       Name = lower("nat-secondary-eip")
#     },
#     local.common_tags,
#   )
# }

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  for_each = var.use_nat_gateway ? local.nat_meta : {}

  connectivity_type = "public"
  subnet_id         = each.value.id
  allocation_id     = aws_eip.nat[each.key].id

  # [Work In Progress] possible a bug because of the provider, specifically in aws_nat_gateway resource
  # - secondary_private_ip_address_count
  # - secondary_allocation_ids
  # - secondary_private_ip_addresses
  # secondary_allocation_ids = length(var.secondary_nat_ips) > 0 ? try(var.secondary_nat_ips[each.key].eip_ids, []) : [for k, v in zipmap(keys(aws_eip.nat_secondary), values(aws_eip.nat_secondary)) : v.id if startswith(k, each.key)]

  tags = merge(
    {
      Name = "${each.value.tags["Name"]}-nat-gw"
    },
    local.common_tags,
  )
}

# NAT Instances
data "aws_ami" "fck-nat-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["fck-nat-al2023-*"] # https://fck-nat.dev/stable/#getting-a-fck-nat-ami
  }
  filter {
    name   = "owner-id"
    values = ["568608671756"]
  }
}

resource "aws_instance" "nat" {
  for_each = !var.use_nat_gateway ? local.nat_meta : {}

  ami                         = data.aws_ami.fck-nat-ami.id
  instance_type               = "t3.micro"
  subnet_id                   = each.value.id
  associate_public_ip_address = true
  source_dest_check           = false
  disable_api_stop            = var.disable_nat_instance_stop_protection
  disable_api_termination     = var.disable_nat_instance_termination_protection

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = true
  }

  tags = merge(
    {
      Name = lower("${var.name}-${each.key}-nat")
    },
    local.common_tags,
  )
}

#------------------------------------------------------------------------------
# Route Tables
#------------------------------------------------------------------------------

# Route table
resource "aws_route_table" "public" {
  for_each = aws_subnet.public

  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = lower("${var.name}-${each.key}-routetable")
    },
  )
}

# Route to access internet
resource "aws_route" "public_internet_route" {
  for_each = aws_route_table.public

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = each.value.id
  gateway_id     = aws_internet_gateway.this.id
}

# Association of Route Table to Subnets
resource "aws_route_table_association" "public_internet_route" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}
