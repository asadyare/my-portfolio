variable "name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "primary_bucket_domain" {
  type = string
}

variable "failover_bucket_domain" {
  type = string
}

variable "logs_bucket_domain" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
