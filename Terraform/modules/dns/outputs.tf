
output "zone_id" { value = aws_route53_zone.primary.zone_id }
output "route53_log_group_arn" { value = aws_cloudwatch_log_group.route53.arn }
output "route53_kms_key_arn" { value = aws_kms_key.route53.arn }
output "route53_dnssec_kms_key_arn" {value = aws_kms_key.route53_dnssec.arn }
