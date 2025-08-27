# ----------------------------------------
# Default settings for the client
# ----------------------------------------
resource "cloudflare_device_settings_policy" "default" {
  account_id  = local.cloudflare_account_id
  name        = "Default"
  description = coalesce(try(var.client_settings["Default"].description, ""), "Default settings for the WARP client")
  default     = true

  allowed_to_leave     = try(var.client_settings["Default"].allowed_to_leave, false)
  auto_connect         = try(var.client_settings["Default"].auto_connect, 0)
  service_mode_v2_mode = "warp"
}

resource "cloudflare_split_tunnel" "default" {
  count = try(length(var.client_settings["Default"].routes) > 0, false) ? 1 : 0

  account_id = local.cloudflare_account_id
  mode       = "include"

  dynamic "tunnels" {
    for_each = { for value in try(var.client_settings["Default"].routes, []) : coalesce(value.host, value.address) => value }
    content {
      host        = tunnels.value.host
      description = tunnels.value.description
      address     = tunnels.value.address
    }
  }
}

resource "cloudflare_fallback_domain" "default" {
  count = try(length(var.client_settings["Default"].domains) > 0, false) ? 1 : 0

  account_id = local.cloudflare_account_id

  dynamic "domains" {
    for_each = { for value in try(var.client_settings["Default"].domains, []) : value.suffix => value }
    content {
      suffix      = domains.value.suffix
      description = domains.value.description
      dns_server  = domains.value.dns_server
    }
  }
}

# ----------------------------------------
# Custom settings for the client based on conditions
# ----------------------------------------
resource "cloudflare_device_settings_policy" "custom" {
  for_each = { for key, val in var.client_settings : key => val if key != "Default" }

  account_id  = local.cloudflare_account_id
  enabled     = each.value.enabled
  precedence  = 1 + each.value.priority
  name        = each.key
  description = each.value.description

  match = each.value.matcher

  allowed_to_leave     = coalesce(each.value.allowed_to_leave, true)
  auto_connect         = coalesce(each.value.auto_connect, 0)
  service_mode_v2_mode = coalesce(each.value.service_mode_v2_mode, "warp")
}

resource "cloudflare_split_tunnel" "custom" {
  for_each = { for key, val in var.client_settings : key => val if key != "Default" }

  account_id = local.cloudflare_account_id
  mode       = "include"
  policy_id  = cloudflare_device_settings_policy.custom[each.key].id

  dynamic "tunnels" {
    for_each = { for value in try(var.client_settings[each.key].routes, []) : coalesce(value.host, value.address) => value }
    content {
      host        = tunnels.value.host
      description = tunnels.value.description
      address     = tunnels.value.address
    }
  }
}

resource "cloudflare_fallback_domain" "custom" {
  for_each = { for key, val in var.client_settings : key => val if key != "Default" }

  account_id = local.cloudflare_account_id
  policy_id  = cloudflare_device_settings_policy.custom[each.key].id

  dynamic "domains" {
    for_each = { for value in try(var.client_settings[each.key].domains, []) : value.suffix => value }
    content {
      suffix      = domains.value.suffix
      description = domains.value.description
      dns_server  = domains.value.dns_server
    }
  }
}
