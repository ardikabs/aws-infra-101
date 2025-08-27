locals {
  domain_name  = trimsuffix(var.domain, ".")
  domain_parts = split(".", local.domain_name)
  domain_tld   = "${element(local.domain_parts, length(local.domain_parts) - 2)}.${element(local.domain_parts, length(local.domain_parts) - 1)}"

  validation_domains = { for k, v in aws_acm_certificate.this.domain_validation_options : replace(v.domain_name, "*.", "") => v if replace(v.domain_name, "*.", "") == v.domain_name }
}

resource "aws_acm_certificate" "this" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  tags = merge(local.common_tags)

  lifecycle {
    create_before_destroy = true
  }
}

data "cloudflare_zone" "this" {
  name = local.domain_tld
}

resource "cloudflare_record" "validation" {
  for_each = local.validation_domains

  zone_id         = data.cloudflare_zone.this.id
  name            = lookup(each.value, "resource_record_name")
  type            = lookup(each.value, "resource_record_type")
  value           = trimsuffix(lookup(each.value, "resource_record_value"), ".")
  ttl             = 60
  allow_overwrite = true
  proxied         = false
  comment         = "Used by ACM to validate the domain, and it managed by Terraform."
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [for k in keys(local.validation_domains) : cloudflare_record.validation[k].hostname]

  timeouts {
    create = "5m"
  }
}
