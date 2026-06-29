locals {
  domain_aliases = distinct(compact(concat([var.domain_name], var.alternate_domain_names)))
  bucket_name    = var.site_bucket_name != "" ? var.site_bucket_name : var.domain_name
  name_prefix    = replace(var.domain_name, ".", "-")

  use_custom_domain = var.route53_zone_name != ""
}
