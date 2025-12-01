terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_cloudfront_distribution" "cdn" {
enabled = true

origin {
domain_name = var.bucket_domain
origin_id = "s3-origin"
}

default_cache_behavior {
target_origin_id = "s3-origin"
viewer_protocol_policy = "redirect-to-https"
allowed_methods = ["GET", "HEAD"]
cached_methods = ["GET", "HEAD"]

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
acm_certificate_arn = var.certificate_arn
ssl_support_method = "sni-only"
}

tags = var.tags
}