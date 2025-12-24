provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "s3_primary" {
  source  = "./modules/s3"
  buckets = var.primary_buckets
  tags    = var.tags
}

module "s3_failover" {
  source  = "./modules/s3"
  buckets = var.failover_buckets
  tags    = var.tags
}

module "logs" {
  source  = "./modules/s3"
  buckets = var.log_buckets
  tags    = var.tags
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

module "cloudfront" {
  source = "./modules/cloudfront"

  s3_bucket_domain_names       = [module.s3_primary.bucket_regional_domain_names["primary-site-bucket"]]
  failover_bucket_domain_names = [module.s3_failover.bucket_regional_domain_names["replica-site-bucket"]]
  logging_bucket_domain_name   = module.logs.bucket_regional_domain_names["logs-bucket"]
  logging_prefix               = "cloudfront-logs"
  acm_certificate_arn          = module.acm.certificate_arn
  name                         = var.domain_name
  waf_log_destination_arn      = var.waf_log_destination_arn
  price_class                  = "PriceClass_100"
  tags                         = var.tags
}

module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  cf_domain   = module.cloudfront.cf_domain
  cf_zone_id  = module.cloudfront.cf_zone_id
  kms_key_arn = var.kms_key_arn
  dns_log_group_arn = var.dns_log_group_arn
  tags        = var.tags
}
