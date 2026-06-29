variable "aws_region" {
  description = "AWS region for regional resources such as S3 and IAM."
  type        = string
  default     = "ap-southeast-2"
}

variable "domain_name" {
  description = "Primary site domain name."
  type        = string
  default     = "dinoleung.com"
}

variable "alternate_domain_names" {
  description = "Additional CloudFront aliases, for example www.dinoleung.com."
  type        = list(string)
  default     = ["www.dinoleung.com"]
}

variable "route53_zone_name" {
  description = "Route 53 hosted zone name. Leave empty to skip ACM DNS validation and DNS records."
  type        = string
  default     = ""
}

variable "site_bucket_name" {
  description = "Override for the S3 bucket storing built static site files. Defaults to domain_name."
  type        = string
  default     = ""
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "price_class must be PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "minimum_tls_version" {
  description = "Minimum TLS protocol version for CloudFront viewer connections."
  type        = string
  default     = "TLSv1.2_2021"
}

variable "enable_deploy_policy" {
  description = "Create an IAM policy that permits syncing the site bucket and invalidating the CloudFront distribution."
  type        = bool
  default     = true
}
