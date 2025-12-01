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
    aws        = aws
    aws.us_east_1 = aws.us_east_1
  }

  domain_name    = var.domain_name
  hosted_zone_id = module.dns.zone_id
  tags           = var.tags
}

module "s3" {
source = "./modules/s3"
bucket_name = var.bucket_name
tags = var.tags
}

module "cloudfront" {
source = "./modules/cloudfront"
bucket_domain = module.s3.bucket_regional_domain_name
certificate_arn = module.acm.certificate_arn
domain_name = var.domain_name
tags = var.tags
}

module "dns" {
source = "./modules/dns"
domain_name = var.domain_name
cf_domain = module.cloudfront.cf_domain
cf_zone_id = module.cloudfront.cf_zone_id
tags = var.tags
}
