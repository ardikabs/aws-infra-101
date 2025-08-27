inputs = {
  account_id       = "987654321098"
  region           = "ap-east-1" # This will be a default region on this AWS account, to override this value, you can set the region in the region.hcl file under `<region>` directory.
  entity_name      = "Backend"
  environment_name = "staging"
}