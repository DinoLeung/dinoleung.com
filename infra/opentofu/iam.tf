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

