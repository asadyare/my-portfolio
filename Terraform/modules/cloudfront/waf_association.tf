resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_cloudfront_distribution.this.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
