locals {
  cloudflare_api_token  = try(data.aws_ssm_parameter.cloudflare["api-token"].value, var.cloudflare_api_token)
  cloudflare_account_id = try(data.aws_ssm_parameter.cloudflare["account-id"].value, var.cloudflare_account_id)
  github_client_id      = try(data.aws_ssm_parameter.cloudflare["github-client-id"].value, var.github_client_id)
  github_client_secret  = try(data.aws_ssm_parameter.cloudflare["github-client-secret"].value, var.github_client_secret)
}

data "aws_ssm_parameter" "cloudflare" {
  for_each = var.use_parameter_store ? var.parameter_store_prefix_map : {}
  name     = each.value
}
