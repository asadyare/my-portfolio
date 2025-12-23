variable "name" {
description = "Base name for CloudFront resources"
type = string
}

variable "s3_bucket_domain_name" {
description = "S3 bucket regional domain name"
type = string
}

variable "acm_certificate_arn" {
description = "ACM certificate ARN in us-east-1"
type = string
}

variable "price_class" {
description = "CloudFront price class"
type = string
default = "PriceClass_100"
}

variable "logging_bucket_domain_name" {
description = "S3 bucket domain name for CloudFront logs"
type = string
}

variable "logging_prefix" {
description = "Prefix for CloudFront logs"
type = string
default = "cloudfront/"
}

variable "failover_bucket_domain_name" {
description = "Secondary S3 bucket domain name for failover"
type = string
}

variable "waf_log_destination_arn" {
description = "Kinesis Firehose ARN for WAF logs"
type = string
}