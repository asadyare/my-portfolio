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