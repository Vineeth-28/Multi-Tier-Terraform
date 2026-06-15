# Terraform Multi-Environment AWS Infrastructure

## Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform.

The infrastructure is organized using:

* Terraform Modules
* Terraform Workspaces
* Reusable Code Structure

A single Terraform codebase is used to provision three isolated environments:

* Development (dev)
* Staging (stage)
* Production (prod)

---

# Architecture

```text
                    Terraform

                         │
                         ▼

                ┌────────────────┐
                │ Terraform Root │
                └────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼

    ┌─────────┐    ┌─────────┐    ┌─────────┐
    │   DEV   │    │  STAGE  │    │  PROD   │
    └─────────┘    └─────────┘    └─────────┘
         │               │               │
         ▼               ▼               ▼

      EC2            EC2            EC2
      S3             S3             S3
   DynamoDB       DynamoDB       DynamoDB
```

---

# Infrastructure Components

## VPC Module

Creates:

* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association

```text
Internet
    │
    ▼
Internet Gateway
    │
    ▼
VPC
    │
    ▼
Public Subnet
```

---

## Security Group Module

Allows:

* SSH (22)
* HTTP (80)

Acts as a firewall for EC2 instances.

---

## EC2 Module

Creates:

* Ubuntu 24.04 Server
* t3.micro Instance

Instance naming based on workspace:

```text
dev-ubuntu
stage-ubuntu
prod-ubuntu
```

---

## S3 Module

Creates environment-specific buckets:

```text
dev-vineet-app-bucket
stage-vineet-app-bucket
prod-vineet-app-bucket
```

---

## DynamoDB Module

Creates environment-specific tables:

```text
dev-users-table
stage-users-table
prod-users-table
```

Partition Key:

```text
id
```

---

# Folder Structure

```text
terraform-multi-tier/

├── modules/
│
│   ├── vpc/
│   │   ├── main.tf
│   │   └── outputs.tf
│
│   ├── security-group/
│   │   ├── main.tf
│   │   └── outputs.tf
│
│   ├── ec2/
│   │   ├── main.tf
│   │   └── outputs.tf
│
│   ├── s3/
│   │   ├── main.tf
│   │   └── outputs.tf
│
│   └── dynamodb/
│       ├── main.tf
│       └── outputs.tf
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── main.tf
```

---

# Terraform Concepts Used

## Provider

```hcl
provider "aws" {
  region = "us-west-2"
}
```

Used to connect Terraform with AWS.

---

## Resource

Example:

```hcl
resource "aws_s3_bucket" "bucket" {
}
```

Represents an AWS object.

---

## Variables

Used to pass values dynamically.

Example:

```hcl
variable "bucket_name" {}
```

---

## Outputs

Used to expose resource information.

Example:

```hcl
output "public_ip" {
}
```

---

## Modules

Modules are reusable Terraform code.

Think of them like functions in programming.

```text
Function  -> Programming
Module    -> Terraform
```

---

## Workspaces

Workspaces allow managing multiple environments using the same code.

```bash
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod
```

Switch environment:

```bash
terraform workspace select prod
```

---

# Deployment Workflow

Initialize Terraform:

```bash
terraform init
```

Validate Configuration:

```bash
terraform validate
```

Review Changes:

```bash
terraform plan
```

Deploy Infrastructure:

```bash
terraform apply
```

Destroy Infrastructure:

```bash
terraform destroy
```

---

# Workspace Strategy

Environment-specific resources are created automatically using:

```hcl
${terraform.workspace}
```

Example:

```hcl
bucket_name = "${terraform.workspace}-vineet-app-bucket"
```

Result:

```text
dev-vineet-app-bucket
stage-vineet-app-bucket
prod-vineet-app-bucket
```

---

# Successful Deployment Evidence

## EC2 Instances

![EC2 Instances](screenshots/ec2-instances.png)

Deployed:

* dev-ubuntu
* stage-ubuntu
* prod-ubuntu

---

## S3 Buckets

![S3 Buckets](screenshots/s3-buckets.png)

Created:

* dev-vineet-app-bucket
* stage-vineet-app-bucket
* prod-vineet-app-bucket

---

## DynamoDB Tables

![DynamoDB Tables](screenshots/dynamodb-tables.png)

Created:

* dev-users-table
* stage-users-table
* prod-users-table

---

# Key Learnings

During implementation the following Terraform concepts were learned:

* Infrastructure as Code (IaC)
* Terraform State
* Terraform Modules
* Terraform Workspaces
* Resource Dependencies
* AWS Networking Basics
* EC2 Provisioning
* S3 Management
* DynamoDB Provisioning
* Terraform Debugging

---

# Future Improvements

* Remote Backend (S3 + DynamoDB State Locking)
* IAM Roles
* Load Balancer
* Auto Scaling Group
* Multi-AZ Architecture
* Private Subnets
* RDS Database
* CI/CD using GitHub Actions

---

# Author

Vineet

DevOps & Cloud Engineering Learning Project
