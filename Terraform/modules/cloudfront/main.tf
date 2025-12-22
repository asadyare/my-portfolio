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

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3"
}
resource "aws_wafv2_web_acl" "log4j_protected" {
  name        = "var.name-webacl"
  scope       = "CLOUDFRONT"
  description = "CloudFront WAF with AWS managed rules including Log4j protection"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesKnownBadInputsRuleSet"
    }
  }

  rule {
    name     = "AWSManagedRulesLog4jRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLog4jRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled    = true
      cloudwatch_metrics_enabled  = true
      metric_name                 = "AWSManagedRulesLog4jRuleSet"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "var.name-webacl"
    sampled_requests_enabled   = true
  }
}


resource "aws_wafv2_web_acl_logging_configuration" "cf" {
  resource_arn = aws_wafv2_web_acl.log4j_protected.arn
  log_destination_configs = [var.waf_log_group_arn]
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.log4j_protected.arn

  origin {
    domain_name = var.primary_bucket_domain
    origin_id   = "primary-s3"
  }

  origin {
    domain_name = var.failover_bucket_domain
    origin_id   = "failover-s3"
  }

  origin_group {
    origin_id = "s3-group"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primary-s3"
    }

    member {
      origin_id = "failover-s3"
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-group"
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

