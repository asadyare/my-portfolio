# Title

Asad Portfolio Infrastructure

Purpose

You use this Terraform setup to deploy your portfolio on AWS. The setup includes S3 for hosting, CloudFront for CDN, and Route53 for DNS.

Requirements
• Terraform version 1.4 or newer
• AWS CLI installed
• AWS credentials set with aws configure
• Domain purchased or imported into Route53

Structure
terraform
modules
modules/s3
modules/ACM
modules/cloudfront
modules/dns
main.tf
output.tf
variables.tf
terraform.tfvars

Deployment Steps

Run terraform init inside the terraform folder.

Run terraform validate to confirm the configuration loads.

Run terraform plan to preview changes.

Run terraform apply to deploy the resources.

Upload index.html or your build output into the S3 bucket.

Wait for CloudFront to finish provisioning.

Visit your CloudFront domain and confirm the site loads.

Add your domain in Route53 when ready.

Request an ACM certificate in us-east-1.

Add the certificate ARN to terraform.tfvars.

Run terraform apply again.

Visit your domain over HTTPS.

Variables
aws_region
aws_profile
project_name
bucket_name
domain_name
certificate_arn
tags

Outputs
S3 bucket id
CloudFront domain name
Route53 zone id

Daily Operations
• To update infrastructure run terraform plan then terraform apply.
• To destroy the stack run terraform destroy.
• To rotate domain certificates request a new ACM certificate and update the ARN in terraform.tfvars.

Architecture

                  User
                   |
                   v
           asad-portfolio.com
                   |
                   v
            Route53 hosted zone
                   |
                   v
            CloudFront CDN
                   |
                   v
       S3 bucket with static site
                   |
                   v
        CloudFront returns response
                   |
                   v
            HTTPS handled by ACM

Flow

User requests asad-portfolio.com.

Route53 resolves the domain to CloudFront.

CloudFront fetches files from the S3 origin.

CloudFront serves the response over HTTPS.

## Architecture overview description

Traffic enters through CloudFront with HTTPS enforced.
CloudFront attaches a WAFv2 Web ACL using AWS managed rule groups.
Requests route to an S3 origin group with a primary and failover bucket.
Failover triggers only on origin error status codes.
ACM provides certificates from us east 1 for CloudFront.
Response headers policy enforces HSTS and secure headers.
Access logs flow to a dedicated S3 logs bucket.
WAF logs stream to a central logging destination.
Route53 hosts public DNS with query logging and DNSSEC enabled.
S3 buckets use KMS encryption, versioning, lifecycle rules, replication, and EventBridge notifications.

## Compliance mapping table

Control area. Implementation. Reference standard.

Transport security.
TLS v1.2_2021 enforced via CloudFront and ACM.
CIS AWS 1.2. NIST SC 13.

Web application firewall.
AWS managed WAF rules with Log4j protection and logging.
CIS AWS 2.10. NIST SI 10.

Logging and monitoring.
CloudFront, WAF, S3, and Route53 logs enabled.
CIS AWS 2.5. NIST AU 2.

Data encryption at rest.
S3 encrypted with customer managed KMS keys.
CIS AWS 2.7. NIST SC 12.

Key management.
KMS rotation enabled and scoped policies applied.
CIS AWS 2.8. NIST KM 1.

Resilience and availability.
CloudFront origin failover with multi bucket S3.
CIS AWS 3.1. NIST CP 10.

DNS protection.
Route53 DNS query logging and DNSSEC signing.
CIS AWS 3.6. NIST SC 20.

Event monitoring.
S3 EventBridge notifications enabled.
CIS AWS 2.4. NIST SI 4.
