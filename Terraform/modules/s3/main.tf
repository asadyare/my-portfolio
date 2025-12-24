resource "aws_s3_bucket" "buckets" {
  for_each = { for b in var.buckets : b.name => b }
  bucket   = each.value.name
  tags     = var.tags
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "buckets" {
#   for_each = aws_s3_bucket.buckets
#   bucket   = each.value.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

resource "aws_s3_bucket_versioning" "buckets" {
  for_each = aws_s3_bucket.buckets
  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = aws_s3_bucket.buckets
  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
for_each = aws_s3_bucket.buckets

bucket = each.value.id

rule {
apply_server_side_encryption_by_default {
sse_algorithm = "aws:kms"
kms_master_key_id = aws_kms_key.s3.arn
}
}
}

resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10

  tags = var.tags
}

resource "aws_s3_bucket_notification" "this" {
for_each = aws_s3_bucket.buckets

bucket = each.value.id
eventbridge = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
for_each = aws_s3_bucket.buckets

bucket = each.value.id

rule {
id = "retention"
status = "Enabled"

expiration {
  days = 365
}


}
}

resource "aws_s3_bucket_logging" "this" {
for_each = aws_s3_bucket.buckets

bucket = each.value.id
target_bucket = aws_s3_bucket.logs.id
target_prefix = "${each.key}/"
}

resource "aws_s3_bucket_replication_configuration" "primary" {
bucket = aws_s3_bucket.primary.id
role = aws_iam_role.replication.arn

rule {
status = "Enabled"

destination {
  bucket        = aws_s3_bucket.replica.arn
  storage_class = "STANDARD"
}


}
}