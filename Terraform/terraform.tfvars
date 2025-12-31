aws_region   = "us-east-1"
name         = "asad-portfolio"
project_name = "asad-portfolio"
domain_name  = "asad-portfolio.com"

tags = {
  owner   = "asad"
  project = "portfolio"
  env     = "prod"
}

buckets = [
  {
    name            = "asad-portfolio-primary-bucket"
    type            = "standard"
    replication_arn = ""
  },
  {
    name            = "asad-portfolio-failover-bucket"
    type            = "standard"
    replication_arn = ""
  },
  {
    name            = "asad-portfolio-logs-bucket"
    type            = "standard"
    replication_arn = ""
  }
]
