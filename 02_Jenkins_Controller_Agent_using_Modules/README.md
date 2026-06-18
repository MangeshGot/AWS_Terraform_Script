# Jenkins Controller-Agent Infrastructure with Terraform

This Terraform project automates the provisioning of a Jenkins Controller-Agent architecture on AWS using modular Terraform code. It creates a complete VPC setup with public and private subnets, security groups, and EC2 instances for both Jenkins Controller and Agent nodes.

## Overview

This project deploys:
- **VPC** with customizable CIDR blocks
- **Public Subnets** (2) for Jenkins Controller with NAT Gateway
- **Private Subnets** (2) for Jenkins Agent with internet access via NAT
- **Security Groups** with appropriate ingress/egress rules
- **EC2 Instances** for Jenkins Controller and Agent
- **Internet Gateway** and **NAT Gateway** for network connectivity
- **Route Tables** for public and private subnet routing

## Project Structure

```
02_Jenkins_Controller_Agent_using_Modules/
├── README.md                           # This file
├── enviroment/
│   ├── devlopement/                    # Development environment configuration
│   │   ├── main.tf                     # Module instantiation
│   │   ├── provider.tf                 # AWS provider configuration
│   │   ├── terraform.tfvars            # Environment-specific variables
│   │   ├── variables.tf                # Variable definitions
│   │   ├── outputs.tf                  # Output definitions
│   │   └── terraform.tfstate           # Terraform state file
│   └── production/                     # Production environment configuration
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── outputs.tf
└── modules/
    └── jenkins_controller_agent/       # Main Terraform module
        ├── vpc.tf                      # VPC creation
        ├── subnets.tf                  # Subnet configuration
        ├── igw.tf                      # Internet Gateway
        ├── nat_igw.tf                  # NAT Gateway
        ├── route_table.tf              # Route table configuration
        ├── security_group.tf           # Security group rules
        ├── instance.tf                 # EC2 instance definitions
        ├── eip.tf                      # Elastic IP allocation
        ├── variables.tf                # Module variables
        └── outputs.tf                  # Module outputs
```

## Prerequisites

Before you begin, ensure you have:

1. **Terraform** installed (v1.0 or higher)
   ```bash
   terraform version
   ```

2. **AWS CLI** configured with credentials
   ```bash
   aws configure
   ```

3. **AWS Account** with appropriate permissions to create:
   - VPC and networking resources
   - EC2 instances
   - Security groups
   - IAM roles (if needed)

4. **SSH Key Pair** created in AWS (used via `key_pair_name` variable)

5. **Valid AMI ID** for your region (default: `ami-091138d0f0d41ff90` for us-east-1)

## Quick Start

### 1. Clone or Navigate to the Project

```bash
cd 02_Jenkins_Controller_Agent_using_Modules/enviroment/devlopement
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan -out=tfplan
```

### 4. Apply the Configuration

```bash
terraform apply tfplan
```

### 5. Access the Outputs

After successful deployment, retrieve the Jenkins Controller IP:

```bash
terraform output
```

## Configuration Variables

All variables are defined in `terraform.tfvars`. Here's what each variable means:

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `vpc_cidr` | string | CIDR block for the VPC | `"192.168.0.0/24"` |
| `public_subnet_1` | string | CIDR for 1st public subnet | `"192.168.0.0/26"` |
| `public_subnet_2` | string | CIDR for 2nd public subnet | `"192.168.0.64/26"` |
| `private_subnet_1` | string | CIDR for 1st private subnet | `"192.168.0.128/26"` |
| `private_subnet_2` | string | CIDR for 2nd private subnet | `"192.168.0.192/26"` |
| `vpc_region` | string | AWS region | `"us-east-1"` |
| `az_1a` | string | Availability Zone 1a | `"us-east-1a"` |
| `az_1b` | string | Availability Zone 1b | `"us-east-1b"` |
| `az_1c` | string | Availability Zone 1c | `"us-east-1c"` |
| `az_1d` | string | Availability Zone 1d | `"us-east-1d"` |
| `access_key` | string | AWS Access Key ID | `"AKIAIOSFODNN7EXAMPLE"` |
| `secret_key` | string | AWS Secret Access Key | `"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"` |
| `instance_type` | string | EC2 instance type | `"t3.micro"` |
| `ami_id` | string | Amazon Machine Image ID | `"ami-091138d0f0d41ff90"` |
| `enviroment` | string | Environment name | `"Developement"` or `"Production"` |
| `key_pair_name` | string | EC2 Key Pair name | `"ketan"` |
| `http_port` | number | Jenkins HTTP port | `8080` |
| `ssh_port` | number | SSH port | `22` |

### Security Note
⚠️ **Important**: Do not commit `terraform.tfvars` or `terraform.tfstate` files to version control as they contain sensitive information (AWS credentials, private IPs). Use:
- `.gitignore` to exclude these files
- AWS Secrets Manager or similar for credential management in production

## Outputs

After applying the Terraform configuration, the following outputs are available:

```bash
Outputs:
jenkins_controller_public_ip = <IP Address>
jenkins_agent_private_ip = <Private IP>
```

Use the `jenkins_controller_public_ip` to:
- Access Jenkins Web Interface: `http://<jenkins_controller_public_ip>:8080`
- SSH into controller: `ssh -i <path-to-key> ec2-user@<jenkins_controller_public_ip>`

## Common Tasks

### View Current State

```bash
terraform show
```

### Plan Changes

```bash
terraform plan
```

### Destroy Infrastructure

```bash
terraform destroy
```

### Use Production Environment

```bash
cd ../production
terraform init
terraform plan
terraform apply
```

## Network Architecture

```
┌─────────────────────────────────────┐
│         VPC (192.168.0.0/24)        │
├─────────────────────────────────────┤
│                                     │
│  Public Subnets                     │
│  ┌──────────────┬──────────────┐    │
│  │192.168.0.0/26│192.168.0.64 │    │
│  │  Subnet 1a   │  Subnet 1b  │    │
│  └──────┬───────┴──────┬──────┘    │
│         │              │            │
│    ┌────▼──────────────▼────┐      │
│    │ Jenkins Controller EC2  │      │
│    │ (Public IP)            │      │
│    └────────────────────────┘      │
│                                    │
│         Internet Gateway           │
│              │                      │
├──────────────┼──────────────────────┤
│              │                      │
│         NAT Gateway                │
│              │                      │
│  Private Subnets                   │
│  ┌──────────────┬──────────────┐   │
│  │192.168.0.128│192.168.0.192 │   │
│  │  Subnet 1c  │  Subnet 1d   │   │
│  └──────┬───────┴──────┬──────┘   │
│         │              │           │
│    ┌────▼──────────────▼────┐     │
│    │  Jenkins Agent EC2     │     │
│    │ (Private IP only)      │     │
│    └────────────────────────┘     │
└────────────────────────────────────┘
```

## Troubleshooting

### Issue: `Error: Missing or invalid credentials`
**Solution**: Ensure AWS credentials are configured:
```bash
aws configure
# Or set environment variables:
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
```

### Issue: `Error: AMI ID not found`
**Solution**: Verify the AMI ID exists in your region:
```bash
aws ec2 describe-images --image-ids ami-091138d0f0d41ff90 --region us-east-1
```

### Issue: `Error: Key pair not found`
**Solution**: Ensure the EC2 key pair exists in your region:
```bash
aws ec2 describe-key-pairs --region us-east-1
```

### Issue: `Error: Instance type not available in AZ`
**Solution**: Verify instance type availability:
```bash
aws ec2 describe-instance-types --instance-types t3.micro --region us-east-1
```

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices.html)

## License

Add your license information here.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Terraform logs: `TF_LOG=DEBUG terraform apply`
3. Check AWS CloudTrail for API calls
4. Review security group rules if connectivity issues occur

---

**Last Updated**: 2026-06-19  
**Terraform Version**: 1.0+  
**AWS Provider Version**: Latest
