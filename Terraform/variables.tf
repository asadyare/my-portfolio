variable "aws_region" { type = string }
variable "name" {type = string}
variable "project_name" { type = string }
variable "buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}
variable "domain_name" { type = string }
variable "hosted_zone_id" { type = string }
variable "acm_certificate_arn" { type = string }
variable "cloudfront_arn" { type = string }
variable "tags" { type = map(string) }