resource "aws_wafv2_web_acl_logging_configuration" "this" {
resource_arn = aws_wafv2_web_acl.this.arn
log_destination_configs = [var.waf_log_destination_arn]
}

resource "aws_wafv2_web_acl" "this" {
name = "${var.name}-waf"
scope = "CLOUDFRONT"

default_action {
allow {}
}

visibility_config {
cloudwatch_metrics_enabled = true
metric_name = "${var.name}-waf"
sampled_requests_enabled = true
}

rule {
name = "AWSManagedRulesJavaRuleSet"
priority = 10

action {
  block {}
}

statement {
  managed_rule_group_statement {
    name        = "AWSManagedRulesJavaRuleSet"
    vendor_name = "AWS"
  }
}

visibility_config {
  cloudwatch_metrics_enabled = true
  metric_name                = "AWSManagedRulesJavaRuleSet"
  sampled_requests_enabled   = true
  }
}

rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    action {
      block {}
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
}

