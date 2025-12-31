terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "s3" {
  description         = "KMS key for S3 encryption"
  deletion_window_in_days = 30
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnableRootPermissions"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "buckets" {
  for_each = { for b in var.buckets : b.name => b }

  bucket = each.value.name
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  rule {
    id     = "${each.key}-lifecycle"
    status = "Enabled"

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket        = each.value.id
  target_bucket = aws_s3_bucket.buckets["logs"].id
  target_prefix = "${each.key}-logs/"
}

resource "aws_s3_bucket_notification" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket      = each.value.id
  eventbridge = true
}

resource "aws_s3_bucket_replication_configuration" "buckets" {
  for_each = { for b in var.buckets : b.name => b if b.replication_arn != "" }

  bucket = aws_s3_bucket.buckets[each.key].id
  role   = each.value.replication_arn

  rule {
    status = "Enabled"
    destination {
      bucket        = each.value.replication_arn
      storage_class = "STANDARD"
    }
  }
}

