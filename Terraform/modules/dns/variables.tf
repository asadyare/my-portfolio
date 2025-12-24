variable "domain_name" {
  type = string
}

variable "cf_domain" {
  type = string
}

variable "cf_zone_id" {
  type = string
}

variable "tags" {
  type = map(string)
}





# variable "domain_name" { type = string }
# variable "cf_domain" { type = string }
# variable "cf_zone_id" { type = string }
# variable "tags" { type = map(string) }
# variable "dns_log_group_arn" { type = string }
# variable "kms_key_arn" { type = string }