provider "aws" {
  region  = var.aws_region
  
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  domain_name    = var.domain_name
  hosted_zone_id = module.dns.zone_id
  tags           = var.tags
}

module "s3" {
source = "./modules/s3"
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
tags = var.tags
}


module "cloudfront" {
source = "./modules/cloudfront"
name = var.name
waf_log_group_arn = module.logging.cloudfront_log_group_arn
primary_bucket_domain = module.s3.bucket_regional_domain_name
failover_bucket_domain = module.s3.bucket_regional_domain_name
logs_bucket_domain = module.s3.bucket_regional_domain_name
bucket_domain = module.s3.bucket_regional_domain_name
certificate_arn = module.acm.certificate_arn
domain_name = var.domain_name
tags = var.tags
}

module "dns" {
source = "./modules/dns"
dns_log_group_arn = module.logging.route53_log_group_arn
kms_key_arn = module.kms.route53_kms_key_arn
domain_name = var.domain_name
cf_domain = module.cloudfront.cf_domain
cf_zone_id = module.cloudfront.cf_zone_id
tags = var.tags
}
