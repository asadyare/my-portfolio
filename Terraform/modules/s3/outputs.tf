output "bucket_regional_domain_names" {
  value = { for k, b in aws_s3_bucket.buckets : k => b.bucket_regional_domain_name }
}









# output "bucket_name" {
#   value = aws_s3_bucket.this.bucket
# }

# output "bucket_arn" {
#   value = aws_s3_bucket.this.arn
# }

# output "bucket_regional_domain_name" {
#   value = aws_s3_bucket.this.bucket_regional_domain_name
# }
