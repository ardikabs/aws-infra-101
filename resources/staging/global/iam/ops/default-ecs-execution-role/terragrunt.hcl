terraform {
  source = "${get_repo_root()}/modules/iam/service"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  role_name        = "DefaultECSExecutionRole"
  role_description = "Default ECS Execution Role. It allows to fetch environment file from S3 bucket, pull image from ECR, and execute ECS task."

  trusted_aws_services = ["ecs-tasks.amazonaws.com", "application-autoscaling.amazonaws.com"]

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  policy = file("${get_terragrunt_dir()}/policy.json")
}