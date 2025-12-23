terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "security" {
name = "${var.name}-security-headers"

security_headers_config {
content_security_policy {
content_security_policy = "default-src 'self'"
override = true
}

strict_transport_security {
  access_control_max_age_sec = 63072000
  include_subdomains         = true
  preload                    = true
  override                   = true
}

xss_protection {
  protection = true
  mode_block = true
  override   = true
}

frame_options {
  frame_option = "DENY"
  override     = true
}

referrer_policy {
  referrer_policy = "same-origin"
  override        = true
}


}
}
data "aws_iam_policy_document" "waf_logging" {
  statement {
    actions   = ["wafv2:PutLoggingConfiguration"]
     resources = [aws_wafv2_web_acl.cf_acl.arn]  # restrict to the actual WebACL
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["wafv2.amazonaws.com"]
    }
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
name = "${var.name}-oac"
origin_access_control_origin_type = "s3"
signing_behavior = "always"
signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
logging_config {
bucket = var.logging_bucket_domain_name
include_cookies = false
prefix = var.logging_prefix
}
web_acl_id = aws_wafv2_web_acl.this.arn
enabled = true
is_ipv6_enabled = true
price_class = var.price_class

origin {
domain_name = var.s3_bucket_domain_name
origin_id = "primary-s3"
origin_access_control_id = aws_cloudfront_origin_access_control.this.id
}

origin {
domain_name = var.failover_bucket_domain_name
origin_id = "failover-s3"
origin_access_control_id = aws_cloudfront_origin_access_control.this.id
}

origin_group {
origin_id = "s3-origin-group"

failover_criteria {
status_codes = [403, 404, 500, 502, 503, 504]
}

member {
origin_id = "primary-s3"
}

member {
origin_id = "failover-s3"
}
}

default_root_object = "index.html"

default_cache_behavior {
target_origin_id = "s3-origin-group"
viewer_protocol_policy = "redirect-to-https"
allowed_methods = ["GET", "HEAD"]
cached_methods = ["GET", "HEAD"]
response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id
forwarded_values {
query_string = false
cookies {
forward = "none"
  }
 }
}

restrictions {
geo_restriction {
locations = "US"
restriction_type = "whitelist"
}
}

viewer_certificate {
# cloudfront_default_certificate = true
acm_certificate_arn = var.acm_certificate_arn
ssl_support_method = "sni-only"
minimum_protocol_version = "TLSv1.2_2021"
}
}