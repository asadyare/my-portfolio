terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# WAFv2 WebACL
resource "aws_wafv2_web_acl" "this" {
  name  = "${var.name}-waf"
  scope = "CLOUDFRONT"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-waf"
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = [ 
      "AWSManagedRulesJavaRuleSet",
      "AWSManagedRulesKnownBadInputsRuleSet",
      "AWSManagedRulesSQLiRuleSet",
      "AWSManagedRulesAmazonIpReputationList",
      "AWSManagedRulesCommonRuleSet"
     ]
     content {
       name     = rule.value
       priority = index([
        "AWSManagedRulesJavaRuleSet",
        "AWSManagedRulesKnownBadInputsRuleSet",
        "AWSManagedRulesSQLiRuleSet",
        "AWSManagedRulesAmazonIpReputationList",
        "AWSManagedRulesCommonRuleSet"
        ], rule.value) * 10 + 1

      statement {
        managed_rule_group_statement {
          name        = rule.value
          vendor_name = "AWS"
        }
      }

      override_action {
        none {}
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value
        sampled_requests_enabled   = true
      }
    }
  }
}

# WAF Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "this" {
  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [var.waf_log_destination_arn]
}

# CloudFront Response Headers Policy
resource "aws_cloudfront_response_headers_policy" "security" {
  name = "${var.name}-security-headers"

  security_headers_config {
    content_security_policy {
      content_security_policy = "default-src 'self'"
      override                = true
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

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "this" {
  name                            = "${var.name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                = "always"
  signing_protocol                = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  is_ipv6_enabled = true
  price_class     = var.price_class
  web_acl_id      = aws_wafv2_web_acl.this.arn
  default_root_object = "index.html"

  origin {
    domain_name            = var.s3_buckets["primary-site-bucket"]
    origin_id              = "primary-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  origin {
    domain_name            = var.s3_buckets["failover-site-bucket"]
    origin_id              = "failover-s3"
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

  default_cache_behavior {
    target_origin_id       = "s3-origin-group"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  logging_config {
    bucket          = var.logging_bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront-logs/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = var.tags
}
