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
