terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_caller_identity" "current" {}
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "EnableRootPermissions"
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = var.tags
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
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_lifecycle_configuration" "buckets" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  rule {
    id     = "retention"
    status = "Enabled"

    expiration { days = 365 }
    abort_incomplete_multipart_upload { days_after_initiation = 7 }
  }
}

# resource "aws_s3_bucket_replication_configuration" "buckets" {
#   for_each = { for b in var.buckets : b.name => b if b.replication_arn != "" }

#   bucket = aws_s3_bucket.buckets[each.key].id
#   role   = each.value.replication_arn

#   rule {
#     status = "Enabled"
#     destination {
#       bucket        = each.value.replication_arn
#       storage_class = "STANDARD"
#     }
#   }
# }

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
  target_bucket = aws_s3_bucket.buckets[var.log_bucket_name].id
  target_prefix = "${each.key}-logs/"
}

resource "aws_s3_bucket_notification" "buckets" {
  for_each = aws_s3_bucket.buckets
  bucket   = each.value.id
  eventbridge = true
}












# resource "aws_kms_key" "s3" {
#   description             = "S3 encryption key"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "RootAccess"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       }
#     ]
#   })

#   tags = var.tags
# }

# resource "aws_s3_bucket" "this" {
#   bucket = var.bucket_name
#   tags   = var.tags
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.s3.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# resource "aws_s3_bucket_versioning" "this" {
#   bucket = aws_s3_bucket.this.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     id     = "retention"
#     status = "Enabled"

#     expiration {
#       days = 365
#     }

#     abort_incomplete_multipart_upload {
#       days_after_initiation = 7
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "this" {
#   bucket = aws_s3_bucket.this.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_logging" "this" {
#   bucket        = aws_s3_bucket.this.id
#   target_bucket = var.log_bucket_name
#   target_prefix = "${var.bucket_name}/"
# }

# resource "aws_s3_bucket_notification" "this" {
#   bucket      = aws_s3_bucket.this.id
#   eventbridge = true
# }

# resource "aws_iam_role" "replication" {
#   name = "${var.bucket_name}-replication"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = { Service = "s3.amazonaws.com" }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_s3_bucket_replication_configuration" "this" {
#   bucket = aws_s3_bucket.this.id
#   role  = aws_iam_role.replication.arn

#   rule {
#     status = "Enabled"

#     destination {
#       bucket        = var.replica_bucket_arn
#       storage_class = "STANDARD"
#     }
#   }
# }
