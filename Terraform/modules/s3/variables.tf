variable "buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}

variable "tags" {
  type = map(string)
}

variable "name" {
  type = string
}