terraform {
  source = "${get_repo_root()}/modules/ecs/cluster"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name = "s-hkg-rdk-primary-ecs-01"
  tier = "primary"
}