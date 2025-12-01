terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

locals {
  dvo = {
    for dvo in aws_acm_certificate.cert.domain_validation_options:
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

resource "aws_acm_certificate" "cert" {
  provider           = aws.us_east_1
  domain_name        = var.domain_name
  validation_method  = "DNS"
  tags               = var.tags
}

resource "aws_route53_record" "cert_validation" {
  provider = aws
  for_each = local.dvo

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}