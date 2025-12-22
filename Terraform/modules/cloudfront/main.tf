terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "security" {
  name = "security-headers"

  security_headers_config {
    content_security_policy {
      content_security_policy = "default-src https:"
      override = true
    }

    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains = true
      preload = true
      override = true
    }

    xss_protection {
      protection = true
      mode_block = true
      override = true
    }
  }
}

resource "aws_wafv2_web_acl" "cf" {
  name  = "cloudfront-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "commonRules"
      sampled_requests_enabled = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "cloudfrontWAF"
    sampled_requests_enabled = true
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.cf.arn

  origin {
    domain_name = var.bucket_domain
    origin_id   = "s3-origin"
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
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

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  logging_config {
    bucket          = var.logs_bucket_domain
    include_cookies = false
    prefix          = "cloudfront/"
  }

  tags = var.tags
}
