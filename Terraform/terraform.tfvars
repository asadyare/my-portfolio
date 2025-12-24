aws_region = "us-east-1"

domain_name    = "asad-portfolio.com"
hosted_zone_id = "Z01561301YNX8SQG6GY3D"
tags = {
  owner   = "asad"
  project = "portfolio"
  env     = "prod"
}

primary_buckets = [
  {
    name            = "my-devsecops-portfolio-bucket"
    type            = "primary"
    replication_arn = "arn:aws:s3:::my-devsecops-portfolio-failover-bucket"
  }
]

failover_buckets = [
  {
    name            = "my-devsecops-portfolio-failover-bucket"
    type            = "failover"
    replication_arn = ""
  }
]

log_buckets = [
  {
    name = "my-devsecops-portfolio-logs-bucket"
  }
]
