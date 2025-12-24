variable "buckets" {
  type = list(object({
    name            = string
    type            = string
    replication_arn = string
  }))
}

variable "tags" { type = map(string) }
variable "log_bucket_name" {
  type = string
}



























# variable "bucket_name" {
#   type = string
# }

# variable "replica_bucket_arn" {
#   type = string
# }

# variable "log_bucket_name" {
#   type = string
# }

# variable "tags" {
#   type = map(string)
# }







# # variable "buckets" {
# #   type = list(object({
# #     name            = string
# #     type            = string
# #     replication_arn = string
# #   }))
# # }

# # variable "tags" {
# #   type = map(string)
# # }
