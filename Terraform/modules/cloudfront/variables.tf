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