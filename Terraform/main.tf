terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [ aws.us_east_1 ]
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# ACM Module
module "acm" {
  source = "./modules/acm"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  domain_name    = var.domain_name
  hosted_zone_id = module.dns.zone_id
  tags           = var.tags
}

# S3 Module
module "s3" {
  source  = "./modules/s3"

  buckets = var.buckets
  tags    = var.tags
}

# CloudFront Module
module "cloudfront" {
  source                  = "./modules/cloudfront"
  name                    = var.name
  kms_key_arn             = module.s3.kms_key_arn
  primary_bucket_domain   = module.s3.bucket_regional_domain_name["${var.project_name}-primary-bucket"]
  failover_bucket_domain  = module.s3.bucket_regional_domain_name["${var.project_name}-failover-bucket"]
  logs_bucket_domain      = module.s3.bucket_regional_domain_name["${var.project_name}-logs-bucket"]
  certificate_arn         = module.acm.certificate_arn
  domain_name             = var.domain_name
  tags                    = var.tags
}

# DNS Module
module "dns" {
  source             = "./modules/dns"
  
  domain_name        = var.domain_name
  cf_domain          = module.cloudfront.cf_domain
  cf_zone_id         = module.cloudfront.cf_zone_id
  tags               = var.tags
}
