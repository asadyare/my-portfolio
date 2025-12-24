variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "waf_log_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}













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
