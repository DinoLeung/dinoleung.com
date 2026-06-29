provider "aws" {
  region = var.aws_region
}

# CloudFront requires viewer certificates to be issued from us-east-1.
provider "aws" {
  alias  = "cloudfront_acm"
  region = "us-east-1"
}
