resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name       = "${var.name}-db-subnet-group"
  subnet_ids = [for key, subnet in aws_subnet.private : subnet.id if length({ for tag_key, tag_value in var.db_subnet_group_tag_selector : tag_key => "true" if subnet.tags[tag_key] == tag_value }) == length(var.db_subnet_group_tag_selector)]
  tags = merge(
    local.common_tags,
    var.db_subnet_group_tag_selector,
    var.db_subnet_group_additional_tags,
  )
}

resource "aws_elasticache_subnet_group" "this" {
  count = var.create_cache_subnet_group ? 1 : 0

  name       = "${var.name}-cache-subnet-group"
  subnet_ids = [for key, subnet in aws_subnet.private : subnet.id if length({ for tag_key, tag_value in var.cache_subnet_group_tag_selector : tag_key => "true" if subnet.tags[tag_key] == tag_value }) == length(var.cache_subnet_group_tag_selector)]
  tags = merge(
    local.common_tags,
    var.cache_subnet_group_tag_selector,
    var.cache_subnet_group_additional_tags,
  )
}
