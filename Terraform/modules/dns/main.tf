resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = var.tags
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

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cf_domain
    zone_id                = var.cf_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudwatch_log_group" "route53" {
name = "/aws/route53/${var.domain_name}"
retention_in_days = 90
tags = var.tags
}
resource "aws_route53_query_log" "this" {
  zone_id = aws_route53_zone.primary.zone_id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53.arn
}

resource "aws_route53_key_signing_key" "this" {
hosted_zone_id = aws_route53_zone.primary.zone_id
key_management_service_arn = aws_kms_key.dnssec.arn
name = "dnssec-key"
}

resource "aws_route53_hosted_zone_dnssec" "this" {
hosted_zone_id = aws_route53_zone.primary.zone_id
}

resource "aws_kms_key" "dnssec" {
enable_key_rotation = true
}