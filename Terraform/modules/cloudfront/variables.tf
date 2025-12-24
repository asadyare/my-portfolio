variable "name" {
  type = string
}

variable "origin_domain" {
  type = string
}

variable "oai_path" {
  type = string
}

variable "log_bucket_domain" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "waf_log_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}








# variable "s3_bucket_domain_names" { type = list(string) }
# variable "failover_bucket_domain_names" { type = list(string) }
# variable "logging_bucket_domain_name" { type = string }
# variable "acm_certificate_arn" { type = string }
# variable "name" { type = string }
# variable "waf_log_destination_arn" { type = string }
# variable "price_class" { type = string }
# variable "tags" { type = map(string) }
# variable "logging_prefix" { type = string }