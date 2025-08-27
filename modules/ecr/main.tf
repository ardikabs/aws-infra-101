locals {
  common_tags = merge({
    "ManagedBy"   = "terraform"
    "Environment" = var.environment_name
    "Entity"      = var.entity_name
    },
    var.additional_tags,
  )

  repositories = merge(
    [
      for namespace, spec in var.repositories : {
        for res, obj in spec.resources :
        trimprefix("${namespace}/${res}", "default/") => {
          owner         = coalesce(try(obj.owner, ""), spec.owner)
          team          = coalesce(try(obj.team, ""), spec.team)
          immutable     = try(spec.immutable, false) ? "IMMUTABLE" : "MUTABLE"
          scan_on_push  = try(spec.scan_on_push, false)
          pull_accounts = coalescelist(try(spec.pull_accounts, []), var.default_pull_accounts)
        }
      }
    ]...
  )
}

data "aws_iam_policy_document" "iam_policy" {
  for_each = local.repositories

  statement {
    sid    = "AllowCrossAccountPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [for account in each.value.pull_accounts : "arn:aws:iam::${account}:root"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

resource "aws_ecr_repository_policy" "policy" {
  for_each   = local.repositories
  repository = aws_ecr_repository.repository[each.key].name
  policy     = data.aws_iam_policy_document.iam_policy[each.key].json
}

resource "aws_ecr_repository" "repository" {
  for_each = local.repositories

  name                 = each.key
  image_tag_mutability = each.value.immutable

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  tags = merge(
    local.common_tags,
    {
      "Owner" = each.value.owner
      "Team"  = each.value.team
    }
  )
}

resource "aws_ecr_lifecycle_policy" "lifecycle" {
  for_each = local.repositories

  repository = aws_ecr_repository.repository[each.key].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}
