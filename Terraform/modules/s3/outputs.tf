output "bucket_regional_domain_names" {
  value = { for k, b in aws_s3_bucket.buckets : k => b.bucket_regional_domain_name }
}
