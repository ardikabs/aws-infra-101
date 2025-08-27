locals {
  network_routes = flatten([
    for key, network in var.virtual_networks : [
      for route in network.routes : {
        vnet_name           = key
        vnet_id             = cloudflare_tunnel_virtual_network.vnet[key].id
        network             = route.network
        network_description = route.description
      }
    ]
  ])
}

resource "random_password" "tunnel_secret" {
  count  = var.create_ecs_deployment || var.store_token_on_parameter_store ? 1 : 0
  length = 64
}

# --------------------------------------
# Management Section
# --------------------------------------
resource "cloudflare_tunnel" "tunnel" {
  name       = var.tunnel_name
  account_id = local.account_id
  secret     = var.create_ecs_deployment || var.store_token_on_parameter_store ? base64sha256(random_password.tunnel_secret[0].result) : var.tunnel_secret
  config_src = "cloudflare"
}

# --------------------------------------
# Network Section
# --------------------------------------
resource "cloudflare_tunnel_virtual_network" "vnet" {
  for_each = var.virtual_networks

  account_id         = local.account_id
  name               = each.key
  comment            = coalesce(each.value.description, "Virtual network for ${each.key} tunnel")
  is_default_network = coalesce(each.value.default, false)
}

resource "cloudflare_tunnel_route" "route" {
  for_each = { for netroute in local.network_routes : "${netroute.vnet_name}-${netroute.network}" => netroute }

  account_id         = local.account_id
  tunnel_id          = cloudflare_tunnel.tunnel.id
  virtual_network_id = each.value.vnet_id
  network            = each.value.network
  comment            = coalesce(each.value.network_description, "Route for ${each.value.network} in ${each.value.vnet_name} virtual network (${cloudflare_tunnel.tunnel.name})")
}
