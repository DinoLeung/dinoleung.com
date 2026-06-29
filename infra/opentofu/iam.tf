data "aws_iam_policy_document" "deploy" {
  count = var.enable_deploy_policy ? 1 : 0

  statement {
    sid = "ListSiteBucket"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.site.arn,
    ]
  }

  statement {
    sid = "SyncSiteObjects"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.site.arn}/*",
    ]
  }

  statement {
    sid = "InvalidateDistribution"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
    ]
    resources = [
      aws_cloudfront_distribution.site.arn,
    ]
  }
}

resource "aws_iam_policy" "deploy" {
  count = var.enable_deploy_policy ? 1 : 0

  name        = "${local.name_prefix}-deploy"
  description = "Deploy static assets for ${var.domain_name}"
  policy      = data.aws_iam_policy_document.deploy[0].json
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.enable_deploy_policy && var.github_oidc_provider_arn == "" ? 1 : 0

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

data "aws_iam_policy_document" "github_actions_deploy_assume_role" {
  count = var.enable_deploy_policy ? 1 : 0

  statement {
    sid     = "AllowGitHubActionsAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.github_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.github_oidc_subjects
    }
  }
}

resource "aws_iam_role" "github_actions_deploy" {
  count = var.enable_deploy_policy ? 1 : 0

  name               = "${local.name_prefix}-github-actions-deploy"
  description        = "GitHub Actions deploy role for ${var.domain_name}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_deploy_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy" {
  count = var.enable_deploy_policy ? 1 : 0

  role       = aws_iam_role.github_actions_deploy[0].name
  policy_arn = aws_iam_policy.deploy[0].arn
}
