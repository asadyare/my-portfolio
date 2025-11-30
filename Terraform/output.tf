output "certificate_arn" {
value = module.acm.certificate_arn
}

output "cloudfront_domain" {
value = module.cloudfront.cf_domain
}

output "cloudfront_zone_id" {
value = module.cloudfront.cf_zone_id
}

output "s3_bucket_domain" {
value = module.s3.bucket_regional_domain_name
}

output "dns_zone_id" {
value = module.dns.zone_id
}