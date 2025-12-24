output "cloudfront_domain_name" {
  value = module.cloudfront.cf_domain
}

output "primary_s3_buckets" {
  value = module.s3_primary.bucket_regional_domain_names
}

output "failover_s3_buckets" {
  value = module.s3_failover.bucket_regional_domain_names
}

output "logs" {
  value = module.logs.bucket_regional_domain_names
}
