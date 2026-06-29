output "site_bucket_name" {
  description = "S3 bucket that stores static site assets."
  value       = aws_s3_bucket.site.id
}

output "site_bucket_arn" {
  description = "ARN of the static site bucket."
  value       = aws_s3_bucket.site.arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "deploy_policy_arn" {
  description = "IAM policy ARN for deploy automation, when enabled."
  value       = var.enable_deploy_policy ? aws_iam_policy.deploy[0].arn : null
}

output "github_actions_deploy_role_arn" {
  description = "IAM role ARN GitHub Actions can assume for deploys, when enabled."
  value       = var.enable_deploy_policy ? aws_iam_role.github_actions_deploy[0].arn : null
}

output "site_urls" {
  description = "Public URLs for the site."
  value = local.use_custom_domain ? [
    for alias in local.domain_aliases : "https://${alias}"
    ] : [
    "https://${aws_cloudfront_distribution.site.domain_name}",
  ]
}
