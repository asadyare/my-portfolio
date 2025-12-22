# Audit checklist

Infrastructure state.
Terraform plan shows no pending changes.
Terraform state stored securely and access restricted.

Transport security.
CloudFront viewer protocol policy set to redirect to HTTPS.
Minimum TLS version set to TLSv1.2_2021.
ACM certificate issued in us east 1 and attached to distribution.

WAF protection.
Web ACL attached to CloudFront distribution.
AWSManagedRulesCommonRuleSet enabled.
AWSManagedRulesKnownBadInputsRuleSet enabled.
WAF logging configured and receiving events.

Logging and monitoring.
CloudFront access logs present in logs bucket.
WAF logs present in configured log destination.
Route53 query logs visible in CloudWatch.
S3 access logging enabled for all buckets.

Data protection.
S3 default encryption uses customer managed KMS keys.
KMS key rotation enabled.
Bucket public access blocks enabled.
Bucket policies scoped to CloudFront access only.

Resilience.
CloudFront origin group configured with primary and failover origins.
Failover status codes configured.
Replica S3 bucket exists and receives replicated objects.

DNS security.
Public hosted zone has DNSSEC enabled.
Key signing key uses managed KMS key.
DNS resolution works after DNSSEC enablement.

Event monitoring.
S3 EventBridge notifications enabled.
Events visible in EventBridge default bus.
