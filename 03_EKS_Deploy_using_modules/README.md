# EKS Deployment using Terraform Modules

This project provisions an Amazon EKS-ready network foundation on AWS using reusable Terraform modules. It creates a VPC, public and private subnets, an internet gateway, and route tables for an EKS environment.

## Project Structure

```text
03_EKS_Deploy_using_modules/
├── README.md
├── enviroment/
│   └── devlopement/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── outputs.tf
└── modules/
    ├── internet_gateway/
    ├── routes/
    ├── subnets/
    └── vpc/
```

## What This Project Creates

- A custom VPC for the EKS environment
- Public and private subnets across multiple availability zones
- Internet gateway for public access
- Route tables for public/private traffic separation
- Module-based Terraform structure for reuse and maintenance

## Prerequisites

Before running Terraform, make sure you have:

- Terraform installed
- AWS CLI configured with valid credentials
- An AWS account with permissions to create VPC and networking resources

## Configure Variables

Update the values in the environment configuration file:

- enviroment/devlopement/terraform.tfvars

Example variables include:

```hcl
eks_vpc_region      = "us-east-1"
eks_access_key      = "YOUR_AWS_ACCESS_KEY"
eks_secret_key      = "YOUR_AWS_SECRET_KEY"
eks_vpc_cidr_block  = "10.0.0.0/16"
eks_public_subnet_1 = "10.0.1.0/24"
eks_public_subnet_2 = "10.0.2.0/24"
eks_private_subnet_1 = "10.0.3.0/24"
eks_private_subnet_2 = "10.0.4.0/24"
environment         = "dev"
az_1a               = "us-east-1a"
az_1b               = "us-east-1b"
az_1c               = "us-east-1c"
az_1d               = "us-east-1d"
```

## Usage

Navigate to the environment directory:

```bash
cd 03_EKS_Deploy_using_modules/enviroment/devlopement
```

Initialize Terraform:

```bash
terraform init
```

Preview the infrastructure changes:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Destroy the infrastructure when no longer needed:

```bash
terraform destroy
```

## Notes

- Do not commit sensitive values such as AWS access keys, secret keys, or state files to version control.
- The project is organized into modules to make it easier to extend for production-grade EKS deployments.
