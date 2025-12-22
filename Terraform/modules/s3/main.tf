terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_s3_bucket" "site" {
bucket = var.bucket_name
tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
bucket = aws_s3_bucket.site.id
versioning_configuration {
  status = "Enabled"
}
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
bucket = aws_s3_bucket.site.id

rule {
id = "lifecycle-cleanup"
status = "Enabled"

expiration {
  days = 365
}
}
}

resource "aws_s3_bucket_public_access_block" "block" {
bucket = aws_s3_bucket.site.id
block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "website" {
bucket = aws_s3_bucket.site.id
}

resource "aws_kms_key" "s3" {
description = "KMS key for S3 bucket default encryption"
deletion_window_in_days = 30
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
bucket = aws_s3_bucket.site.id

rule {
apply_server_side_encryption_by_default {
sse_algorithm = "aws:kms"
kms_master_key_id = aws_kms_key.s3.arn
}
}
}

resource "aws_s3_bucket" "logs" {
bucket = "${var.bucket_name}-logs"

tags = var.tags
}

resource "aws_s3_bucket_logging" "site_logs" {
bucket = aws_s3_bucket.site.id
target_bucket = aws_s3_bucket.logs.id
target_prefix = "s3-access-logs/"
}

resource "aws_iam_role" "replication" {
name = "${var.bucket_name}-replication-role"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = "sts:AssumeRole"
Effect = "Allow"
Principal = {
Service = "s3.amazonaws.com"
}
}
]
})
}

resource "aws_s3_bucket_replication_configuration" "replication" {
bucket = aws_s3_bucket.site.id
role = aws_iam_role.replication.arn

rule {
id = "replicate-all"
status = "Enabled"
destination {
bucket = aws_s3_bucket.replica.arn
storage_class = "STANDARD"
}
}
}

output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}