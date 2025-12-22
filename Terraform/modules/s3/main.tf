terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

data "aws_caller_identity" "current" {}

# KMS key for S3 encryption
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

# Primary site bucket
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Logs bucket
resource "aws_s3_bucket" "logs" {
  bucket = "${var.bucket_name}-logs"
  tags   = var.tags
}

# Replica bucket for cross-region replication
resource "aws_s3_bucket" "logs_replica" {
  bucket = "${var.bucket_name}-logs-replica"
  tags   = var.tags
  region = "us-east-1"
}

# Replication IAM Role
resource "aws_iam_role" "replication" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication" {
  name = "s3-replication-policy"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = [
          "${aws_s3_bucket.site.arn}/*",
          "${aws_s3_bucket.logs.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = [
          "${aws_s3_bucket.logs_replica.arn}/*"
        ]
      }
    ]
  })
}

# Enable replication for site bucket
resource "aws_s3_bucket_replication_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-site-to-replica"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.logs_replica.arn
      storage_class = "STANDARD"
    }

    filter { prefix = "" }
  }
}

# Enable replication for logs bucket
resource "aws_s3_bucket_replication_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-logs-to-replica"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.logs_replica.arn
      storage_class = "STANDARD"
    }

    filter { prefix = "" }
  }
}

# Enable public access block
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    id     = "site-lifecycle"
    status = "Enabled"

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "logs-lifecycle"
    status = "Enabled"

    expiration {
      days = 180
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Enable access logging
resource "aws_s3_bucket_logging" "site" {
  bucket = aws_s3_bucket.site.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "site-logs/"
}

# Event notifications
resource "aws_s3_bucket_notification" "site" {
  bucket = aws_s3_bucket.site.id
  eventbridge = true
}

resource "aws_s3_bucket_notification" "logs" {
  bucket = aws_s3_bucket.logs.id
  eventbridge = true
}
