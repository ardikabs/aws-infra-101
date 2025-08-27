resource "cloudflare_access_identity_provider" "github_oauth" {
  account_id = local.cloudflare_account_id
  name       = "GitHub OAuth"
  type       = "github"
  config {
    client_id     = local.github_client_id
    client_secret = local.github_client_secret
  }
}


resource "cloudflare_access_policy" "access_policy" {
  account_id = local.cloudflare_account_id
  name       = "WARP Enrollment Policy"
  decision   = "allow"

  include {
    github {
      identity_provider_id = cloudflare_access_identity_provider.github_oauth.id
      name                 = var.github_org
      teams                = var.github_teams
    }
  }
}

resource "cloudflare_access_application" "app_launcher" {
  account_id                = local.cloudflare_account_id
  name                      = "App Launcher"
  domain                    = "${var.cloudflare_team_name}.cloudflareaccess.com"
  type                      = "app_launcher"
  session_duration          = "24h"
  auto_redirect_to_identity = true
  app_launcher_visible      = false
  allowed_idps = [
    cloudflare_access_identity_provider.github_oauth.id,
  ]

  policies = [
    cloudflare_access_policy.access_policy.id,
  ]
}

resource "cloudflare_access_application" "warp" {
  account_id                = local.cloudflare_account_id
  name                      = "Warp Login App"
  domain                    = "${var.cloudflare_team_name}.cloudflareaccess.com/warp"
  type                      = "warp"
  session_duration          = "24h"
  auto_redirect_to_identity = true
  app_launcher_visible      = false
  allowed_idps = [
    cloudflare_access_identity_provider.github_oauth.id,
  ]

  policies = [
    cloudflare_access_policy.access_policy.id,
  ]
}
