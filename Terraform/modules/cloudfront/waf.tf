resource "aws_wafv2_web_acl_logging_configuration" "this" {
resource_arn = aws_wafv2_web_acl.this.arn
log_destination_configs = [var.waf_log_destination_arn]
}

resource "aws_wafv2_web_acl" "this" {
name = "${var.name}-web-acl"
scope = "CLOUDFRONT"

default_action {
allow {}
}

visibility_config {
cloudwatch_metrics_enabled = true
metric_name = "${var.name}-web-acl"
sampled_requests_enabled = true
}

rule {
name = "AWSManagedRulesKnownBadInputs"
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
  cloudwatch_metrics_enabled = true
  metric_name                = "KnownBadInputs"
  sampled_requests_enabled   = true
}


}

rule {
name = "AWSManagedRulesJavaRuleSet"
priority = 2

override_action {
none {}
}

statement {
managed_rule_group_statement {
name = "AWSManagedRulesJavaRuleSet"
vendor_name = "AWS"
}
}

visibility_config {
cloudwatch_metrics_enabled = true
metric_name = "AWSManagedRulesJavaRuleSet"
sampled_requests_enabled = true
}
}
}
  