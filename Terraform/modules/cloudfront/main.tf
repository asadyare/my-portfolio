terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/waf/cloudfront"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn
  tags              = var.tags
}

resource "aws_wafv2_web_acl" "this" {
  name  = "${var.name}-waf"
  scope = "CLOUDFRONT"

  default_action { 
    allow {} 
    }
    
  
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "knownbadinputs"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "anonymousiplist"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }
}


resource "aws_wafv2_web_acl_logging_configuration" "this" {
  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.name
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.this.arn
  aliases             = [var.domain_name]

  origin {
    domain_name              = var.primary_bucket_domain
    origin_id                = "primary"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  origin {
    domain_name              = var.failover_bucket_domain
    origin_id                = "failover"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  origin_group {
    origin_id = "failover-group"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member { origin_id = "primary" }
    member { origin_id = "failover" }
  }

  default_cache_behavior {
    target_origin_id       = "failover-group"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  logging_config {
    bucket = var.logs_bucket_domain
    prefix = "cloudfront/"
  }

  tags = var.tags
}
