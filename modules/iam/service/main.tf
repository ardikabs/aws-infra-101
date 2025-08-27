module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v5.39.1"

  create_role      = true
  role_name        = var.role_name
  role_description = var.role_description

  role_requires_mfa = false

  trusted_role_arns     = var.trusted_role_arns
  trusted_role_services = var.trusted_aws_services

  custom_role_policy_arns = var.policy_arns

  tags = merge(
    {
      "ManagedBy" = "terraform"
    },
    var.additional_tags
  )
}

resource "aws_iam_role_policy" "inline" {
  count  = var.policy != null ? 1 : 0
  role   = module.iam_role.iam_role_name
  policy = var.policy
}
