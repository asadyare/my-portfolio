variable "aws_region" {
  type = string
}

variable "name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}

variable "certificate_arn" {
  type = string
}

variable "zone_id" {
  type = string
}
