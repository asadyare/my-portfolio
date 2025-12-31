output "certificate_arn" { value = aws_acm_certificate.cert.arn }
output "validation_status" { value = aws_acm_certificate_validation.cert_validation_complete.id }