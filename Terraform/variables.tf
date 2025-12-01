variable "aws_region" { type = string }

variable "project_name" { type = string }
variable "bucket_name" { type = string }
variable "domain_name" { type = string }
variable "hosted_zone_id" { type = string }
variable "tags" { type = map(string) }