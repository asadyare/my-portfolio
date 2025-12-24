provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name = var.domain_name
  tags        = var.tags
}

module "cloudfront" {
  source = "./modules/cloudfront"

  name                  = var.project_name
  origin_domain         = module.s3_primary.bucket_regional_domain_name
  oai_path              = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
  log_bucket_domain     = module.s3_logs.bucket_regional_domain_name
  acm_certificate_arn   = module.acm.certificate_arn
  waf_log_arn           = var.waf_log_arn
  tags                  = var.tags
}

module "dns" {
  source = "./modules/dns"

  domain_name = var.domain_name
  cf_domain   = module.cloudfront.cf_domain
  cf_zone_id  = module.cloudfront.cf_zone_id
  tags        = var.tags
}

















# provider "aws" {
#   region = var.aws_region
# }

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }

# module "s3_primary" {
#   source = "./modules/s3"

#   bucket_name        = "asad-primary-site"
#   replica_bucket_arn = module.s3_failover.bucket_arn
#   log_bucket_name    = module.s3_logs.bucket_name

#   tags = var.tags
# }

# module "s3_failover" {
#   source = "./modules/s3"

#   bucket_name        = "asad-failover-site"
#   replica_bucket_arn = module.s3_primary.bucket_arn
#   log_bucket_name    = module.s3_logs.bucket_name

#   tags = var.tags
# }

# module "s3_logs" {
#   source = "./modules/s3"

#   bucket_name        = "asad-access-logs"
#   replica_bucket_arn = module.s3_primary.bucket_arn
#   log_bucket_name    = "asad-access-logs"

#   tags = var.tags
# }


# module "acm" {
#   source = "./modules/acm"

#   providers = {
#     aws.us_east_1 = aws.us_east_1
#   }

#   domain_name    = var.domain_name
#   hosted_zone_id = module.dns.zone_id
#   tags           = var.tags
# }

# module "cloudfront" {
#   source = "./modules/cloudfront"

#   s3_bucket_domain_names       = [module.s3_primary.bucket_regional_domain_names["primary-site-bucket"]]
#   failover_bucket_domain_names = [module.s3_failover.bucket_regional_domain_names["replica-site-bucket"]]
#   logging_bucket_domain_name   = module.logs.bucket_regional_domain_names["logs-bucket"]
#   logging_prefix               = "cloudfront-logs"
#   acm_certificate_arn          = module.acm.certificate_arn
#   name                         = var.domain_name
#   waf_log_destination_arn      = var.waf_log_destination_arn
#   price_class                  = "PriceClass_100"
#   tags                         = var.tags
# }

# module "dns" {
#   source      = "./modules/dns"
#   domain_name = var.domain_name
#   cf_domain   = module.cloudfront.cf_domain
#   cf_zone_id  = module.cloudfront.cf_zone_id
#   kms_key_arn = var.kms_key_arn
#   dns_log_group_arn = var.dns_log_group_arn
#   tags        = var.tags
# }
