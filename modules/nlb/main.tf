data "aws_vpc" "selected" {
  filter {
    name   = "tag:Environment"
    values = [var.environment_name]
  }
}

data "aws_subnets" "public" {
  count = length(var.subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Tier = "public"
  }
}

resource "aws_lb" "this" {
  name               = local.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = try(data.aws_subnets.public[0].ids, var.subnet_ids)
  security_groups    = concat(try([module.security_group[0].security_group_id], []), var.security_group_ids)

  enable_cross_zone_load_balancing                             = true
  enforce_security_group_inbound_rules_on_private_link_traffic = "off"

  enable_deletion_protection = var.enable_deletion_protection

  tags = local.common_tags

  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource "aws_lb_target_group" "this" {
  for_each               = var.ingress_rules
  name                   = "${local.name}-${each.key}-tg"
  port                   = each.value.target_port
  protocol               = coalesce(each.value.target_protocol, "HTTP")
  target_type            = "ip"
  vpc_id                 = data.aws_vpc.selected.id
  slow_start             = each.value.slow_start
  preserve_client_ip     = true
  connection_termination = false

  target_health_state {
    enable_unhealthy_connection_termination = contains(["TCP", "TLS"], coalesce(each.value.target_protocol, "HTTP"))
  }

  tags = merge(
    local.common_tags,
    {
      "ResourceRef" = aws_lb.this.arn
    }
  )
}

data "aws_acm_certificate" "cert" {
  for_each = {
    for k, v in var.ingress_rules : k => v if v.certificate_selector != null
  }

  domain = each.value.certificate_selector.domain
}

resource "aws_lb_listener" "this" {
  for_each = var.ingress_rules

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol # TCP or TLS
  ssl_policy        = coalesce(each.value.protocol, "") == "TLS" ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn   = try(data.aws_acm_certificate.cert[each.key].arn, each.value.certificate_arn)
  alpn_policy       = each.value.alpn_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  tags = merge(
    local.common_tags,
    {
      "ResourceRef" = aws_lb.this.arn
    }
  )

  timeouts {
    create = "10m"
    update = "10m"
  }
}
