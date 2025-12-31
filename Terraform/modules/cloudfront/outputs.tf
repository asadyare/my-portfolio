output "cf_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cf_zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}

output "waf_log_group_arn" {
  value = aws_cloudwatch_log_group.waf.arn
}
