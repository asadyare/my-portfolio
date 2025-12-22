terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

locals {
  buckets = [
    { name = var.bucket_name, type = "site" },
    { name = "${var.bucket_name}-logs", type = "logs" },
    { name = "${var.bucket_name}-logs-replica", type = "logs_replica" }
  ]
}

# Create buckets
resource "aws_s3_bucket" "buckets" {
  for_each = { for b in local.buckets : b.type => b }

  bucket = each.value.name
  tags   = var.tags
  
}

# Public access block
resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption with KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

# Lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  rule {
    id     = "${each.key}-lifecycle"
    status = "Enabled"
    expiration {
      days = each.key == "site" ? 365 : 180
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Enable bucket logging for site and replica buckets
resource "aws_s3_bucket_logging" "site_logs" {
  bucket        = aws_s3_bucket.buckets["site"].id
  target_bucket = aws_s3_bucket.buckets["logs"].id
  target_prefix = "site-logs/"
}

resource "aws_s3_bucket_logging" "logs_replica_logs" {
  bucket        = aws_s3_bucket.buckets["logs-replica"].id
  target_bucket = aws_s3_bucket.buckets["logs"].id
  target_prefix = "logs-replica/"
}

# Event notifications via EventBridge
resource "aws_s3_bucket_notification" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  eventbridge = true
}

# S3 replication configuration for site -> logs-replica
resource "aws_iam_role" "replication" {
  name = "s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "s3.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "site" {
  bucket = aws_s3_bucket.buckets["site"].id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-to-logs-replica"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.buckets["logs-replica"].arn
      storage_class = "STANDARD"
    }
  }
}