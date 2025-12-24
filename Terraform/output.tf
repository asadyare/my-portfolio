output "cloudfront_domain_name" {
  value = module.cloudfront.cf_domain
}

output "cloudfront_zone_id" {
  value = module.cloudfront.cf_zone_id
}

output "primary_s3_bucket_domains" {
  value = module.s3_primary.bucket_regional_domain_names
}

output "failover_s3_bucket_domains" {
  value = module.s3_failover.bucket_regional_domain_names
}

output "log_s3_bucket_domains" {
  value = module.logs.bucket_regional_domain_names
}

output "acm_certificate_arn" {
  value = module.acm.certificate_arn
}
