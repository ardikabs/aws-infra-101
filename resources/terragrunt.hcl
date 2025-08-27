locals {
  state_account_id = "123456789012"
  state_region     = "ap-east-1"
  state_bucket     = "tf-state"
  state_lock_table = "tf-lock"

  apply_requirements = read_terragrunt_config(find_in_parent_folders("apply_requirements.hcl", "ignore"), { inputs = { requirements = [] } })

  extra_atlantis_dependencies = [
    find_in_parent_folders("cloud.hcl", "ignore"),
    find_in_parent_folders("region.hcl", "ignore"),
    find_in_parent_folders("environment.hcl", "ignore"),
    find_in_parent_folders("team.hcl", "ignore")
  ]

  atlantis_apply_requirements = local.apply_requirements.inputs.requirements

  cloud_vars  = read_terragrunt_config(find_in_parent_folders("cloud.hcl", "ignore"), { inputs = {} })
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "ignore"), { inputs = {} })
  env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl", "ignore"), { inputs = {} })
  team_vars   = read_terragrunt_config(find_in_parent_folders("team.hcl", "ignore"), { inputs = {} })

  combined_inputs = merge(
    local.cloud_vars.inputs,
    local.region_vars.inputs,
    local.env_vars.inputs,
    local.team_vars.inputs,
  )

  predefined_inputs = merge(
    local.combined_inputs,
    {
      // This is used when a resource is working together with AWS, such as Cloudflare and AWS in Cloudflare Tunnel resource.
      // In such cases, we differentiate AWS-related variables by adding an aws_* prefix,
      // such as changing account_id to aws_account_id and region to aws_region.
      aws_account_id = try(local.combined_inputs.account_id, "")
      aws_region     = try(local.combined_inputs.region, "ap-east-1")
    }
  )
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    encrypt        = true
    region         = local.state_region
    key            = "${path_relative_to_include()}/terraform.tfstate"
    bucket         = "${local.state_bucket}-${local.state_account_id}"
    dynamodb_table = "${local.state_lock_table}-${local.state_account_id}"
    role_arn       = "arn:aws:iam::${local.state_account_id}:role/Bootstrap"
    session_name   = "TerragruntBackendSession-${local.predefined_inputs.account_id}"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "skip"
  contents  = <<EOF
provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${local.predefined_inputs.account_id}:role/Bootstrap"
    session_name = "TerragruntSession"
  }
  region              = "${local.predefined_inputs.region}"
  allowed_account_ids = ["${local.predefined_inputs.account_id}"]
}
EOF
}

inputs = local.predefined_inputs