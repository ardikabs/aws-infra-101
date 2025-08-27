locals {
  common_tags = {
    ManagedBy   = "terraform"
    Environment = var.environment_name
    Entity      = var.entity_name
  }

  domain_name = trimsuffix(var.tld, ".")
}

data "cloudflare_zone" "this" {
  name = local.domain_name
}

resource "cloudflare_record" "record" {
  for_each = var.records

  zone_id = data.cloudflare_zone.this.id
  name    = each.key
  value   = each.value.value
  type    = each.value.type
  ttl     = coalesce(each.value.ttl, 60)
  proxied = coalesce(each.value.proxied, false)
  # Only available for other than Free plan
  # tags    = [for key, value in merge(coalesce(each.value.tags, {}), local.common_tags) : replace("${key}:${value}", " ", "")]
  # Temporary use comment
  comment = join(" ", [for key, value in merge(coalesce(each.value.tags, {}), local.common_tags) : replace("${key}:${value}", " ", "")])
}
