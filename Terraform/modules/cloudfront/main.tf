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

resource "aws_cloudfront_origin_access_control" "this" {
name = "${var.name}-oac"
origin_access_control_origin_type = "s3"
signing_behavior = "always"
signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
enabled = true
is_ipv6_enabled = true
price_class = var.price_class

origin {
domain_name = var.s3_bucket_domain_name
origin_id = "s3-origin"
origin_access_control_id = aws_cloudfront_origin_access_control.this.id
}

default_root_object = "index.html"

default_cache_behavior {
target_origin_id = "s3-origin"
viewer_protocol_policy = "redirect-to-https"

allowed_methods = [
  "GET",
  "HEAD"
]

cached_methods = [
  "GET",
  "HEAD"
]

forwarded_values {
  query_string = false

  cookies {
    forward = "none"
  }
}


}

restrictions {
geo_restriction {
restriction_type = "none"
}
}

viewer_certificate {
acm_certificate_arn = var.acm_certificate_arn
ssl_support_method = "sni-only"
minimum_protocol_version = "TLSv1.2_2021"
}

web_acl_id = aws_wafv2_web_acl.this.arn
}