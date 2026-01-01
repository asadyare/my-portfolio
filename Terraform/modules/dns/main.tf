terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = var.tags
}

resource "aws_kms_key" "route53_logs" {
  description         = "Route53 query logs key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RootAccess"
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

resource "aws_cloudwatch_log_group" "route53" {
  name              = "/aws/route53/query-logs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.route53_logs.arn
  tags              = var.tags
}

resource "aws_route53_query_log" "this" {
  zone_id                  = aws_route53_zone.primary.zone_id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53.arn
}

resource "aws_kms_key" "route53_dnssec" {
  description                  = "Route53 DNSSEC key"
  key_usage                    = "SIGN_VERIFY"
  customer_master_key_spec     = "ECC_NIST_P256"
  deletion_window_in_days      = 7
  enable_key_rotation          = false
}

data "aws_iam_policy_document" "route53_dnssec" {
  # checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  # checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  # checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
	
  statement {
    sid = "AllowRoute53DNSSECService"

    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }

    actions = [
      "kms:DescribeKey",
      "kms:GetPublicKey",
      "kms:Sign"
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowAccountRoot"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key_policy" "route53_dnssec" {
  key_id = aws_kms_key.route53_dnssec.id
  policy = data.aws_iam_policy_document.route53_dnssec.json
}

resource "aws_route53_key_signing_key" "dnssec" {
  hosted_zone_id             = aws_route53_zone.primary.zone_id
  key_management_service_arn = aws_kms_key.route53_dnssec.arn
  name                       = "dnssec-key"

  depends_on = [
    aws_kms_key_policy.route53_dnssec
  ]
}

resource "aws_route53_hosted_zone_dnssec" "dnssec" {
  hosted_zone_id = aws_route53_zone.primary.zone_id

  depends_on = [
    aws_route53_key_signing_key.dnssec
  ]
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cf_domain
    zone_id                = var.cf_zone_id
    evaluate_target_health = false
  }
}
