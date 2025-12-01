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