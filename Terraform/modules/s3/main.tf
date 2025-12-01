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

resource "aws_s3_bucket_website_configuration" "website" {
bucket = aws_s3_bucket.site.id

index_document {
suffix = "index.html"
}
}

resource "aws_s3_bucket_public_access_block" "public_access" {
bucket = aws_s3_bucket.site.id
block_public_acls = false
block_public_policy = false
ignore_public_acls = false
restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy" {
bucket = aws_s3_bucket.site.id
policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Sid = "PublicRead"
Effect = "Allow"
Principal = "*"
Action = "s3:GetObject"
Resource = "${aws_s3_bucket.site.arn}/*"
}
]
})
}