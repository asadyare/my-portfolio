terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = var.tags
}

resource "aws_route53_query_log" "dns" {
  cloudwatch_log_group_arn = var.dns_log_group_arn
  zone_id                 = aws_route53_zone.primary.zone_id
}

resource "aws_route53_key_signing_key" "dnssec" {
  hosted_zone_id = aws_route53_zone.primary.zone_id
  key_management_service_arn = var.kms_key_arn
  name = "dnssec-key"
}

resource "aws_route53_hosted_zone_dnssec" "dnssec" {
  hosted_zone_id = aws_route53_zone.primary.zone_id
}


resource "aws_route53_record" "root" {
zone_id = aws_route53_zone.primary.zone_id
name = var.domain_name
type = "A"

alias {
name = var.cf_domain
zone_id = var.cf_zone_id
evaluate_target_health = false
}
}

resource "aws_cloudwatch_log_group" "route53" {
name = "/aws/route53/query-logs"
retention_in_days = 365
tags = var.tags
kms_key_id = aws_kms_key.route53.arn
}


resource "aws_kms_key" "route53" {
description = "Route53 query logs key"
enable_key_rotation = true

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowRootAccount"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
