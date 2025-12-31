output "bucket_regional_domain_name" {
  value = { for b, resource in aws_s3_bucket.buckets : b => resource.bucket_regional_domain_name }
}

output "kms_key_arn" {
  value = aws_kms_key.s3.arn
}
