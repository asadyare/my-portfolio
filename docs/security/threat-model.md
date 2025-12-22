# Threat model summary

Assets.
Static website content.
TLS certificates.
DNS records.
Access logs.
Encryption keys.

Entry points.
Public HTTPS endpoints on CloudFront.
DNS queries through Route53.
S3 object access through CloudFront origins.

Threats addressed.
Man in the middle attacks blocked through enforced TLS v1.2_2021.
Injection and known exploit patterns blocked through managed WAF rule groups.
Log4j lookup attacks blocked through KnownBadInputs rules.
Data exposure reduced through private S3 buckets and origin access control.
DNS spoofing reduced through DNSSEC signing.
Availability risks reduced through CloudFront origin failover.

Threats accepted.
Single replication destination per S3 bucket accepted for cost control.
Managed WAF rules used instead of custom rules to reduce rule maintenance risk.

Mitigations.
Encryption in transit and at rest across all data paths.
Centralised logging for CloudFront, WAF, S3, and DNS.
Least privilege IAM roles for replication and logging.
Automated infrastructure defined through Terraform for repeatability.
