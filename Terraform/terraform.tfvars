aws_region       = "us-east-1"
name             = "asad-portfolio"
project_name     = "asad-portfolio"
domain_name      = "asad-portfolio.com"
certificate_arn  = "arn:aws:acm:us-east-1:733366528696:certificate/cf881b0d-b62b-4001-b242-25fd78657191"
zone_id          = "Z09458031QK4UZP2UXBY5"

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
