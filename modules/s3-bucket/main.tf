locals {
  common_tags = merge({
    "ManagedBy"   = "terraform"
    "Name"        = var.name
    "Environment" = var.environment_name
    "Entity"      = var.entity_name
    "Team"        = var.team_name
    "ServiceName" = coalesce(var.service_name, "infrastructure")
    },
    var.additional_tags,
  )

  is_self_managed_policy = var.inline_policy != null || ((length(var.allowed_roles_to_read) > 0 || length(var.allowed_roles_to_edit) > 0))
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "v4.1.2"

  bucket        = var.name
  force_destroy = var.force_destroy

  attach_policy = local.is_self_managed_policy

  policy = local.is_self_managed_policy ? try(data.aws_iam_policy_document.policy[0].json, var.inline_policy) : null

  tags = local.common_tags

  acl                = var.enable_acl ? "private" : null
  block_public_acls  = !var.enable_acl
  ignore_public_acls = !var.enable_acl

  versioning = {
    status = var.enable_versioning
  }
}

data "aws_iam_policy_document" "policy" {
  count = local.is_self_managed_policy ? 1 : 0

  dynamic "statement" {
    for_each = length(var.allowed_roles_to_read) > 0 ? [1] : []

    content {
      sid    = "ReadAccessPolicy"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketLocation",
      ]

      principals {
        type        = "AWS"
        identifiers = var.allowed_roles_to_read
      }

      resources = [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.allowed_roles_to_edit) > 0 ? [1] : []

    content {
      sid    = "EditAccessPolicy"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketLocation",
        "s3:GetBucketVersioning",
        "s3:GetObject",
        "s3:GetObjectTagging",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionTagging",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:DeleteObjectVersionTagging",
      ]

      principals {
        type        = "AWS"
        identifiers = var.allowed_roles_to_edit
      }

      resources = [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*",
      ]
    }
  }
}
