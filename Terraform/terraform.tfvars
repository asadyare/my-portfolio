aws_region = "us-east-1"


project_name = "asad-portfolio"
buckets = [
  {
    name            = "${var.project_name}-primary-bucket"
    type            = "standard"
    replication_arn = module.s3_replication.replication_role_arn
  },
  {
    name            = "${var.project_name}-failover-bucket"
    type            = "standard"
    replication_arn = module.s3_replication.replication_role_arn
  },
  {
    name            = "${var.project_name}-logs-bucket"
    type            = "standard"
    replication_arn = module.s3_replication.replication_role_arn
  }
]
domain_name = "asad-portfolio.com"
acm_certificate_arn = "arn:aws:acm:us-east-1:733366528696:certificate/f60d94b3-0f31-4456-b882-46b9885d00ef"
cloudfront_arn = "arn:aws:cloudfront::733366528696:distribution/E1MKU8LSS8EY9R"

hosted_zone_id = "Z03947583S3PF4TCIOKDK"

tags = {
owner = "asad"
project = "portfolio"
env = "prod"
}