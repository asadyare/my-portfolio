variable "aws_region" { type = string }
variable "domain_name" { type = string }
variable "hosted_zone_id" { type = string }
variable "tags" { type = map(string) }

variable "primary_buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}

variable "failover_buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}

variable "log_buckets" {
  type = list(object({
    name = string
  }))
}

variable "acm_certificate_arn" { type = string }













# variable "aws_region" { type = string }

# variable "domain_name" { type = string }

# variable "primary_buckets" {
#   type = list(object({
#     name            = string
#     type            = string
#     replication_arn = string
#   }))
# }

# variable "failover_buckets" {
#   type = list(object({
#     name            = string
#     type            = string
#     replication_arn = string
#   }))
# }

# variable "log_buckets" {
#   type = list(object({
#     name            = string
#     type            = string
#     replication_arn = string
#   }))
# }

# variable "tags" { type = map(string) }

# variable "waf_log_destination_arn" { type = string }

# variable "kms_key_arn" { type = string }

# variable "dns_log_group_arn" { type = string }
