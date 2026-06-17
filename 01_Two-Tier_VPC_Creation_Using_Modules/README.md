# AWS Terraform Scripts

This repository contains Terraform configurations for creating and managing AWS infrastructure, specifically focusing on Two-Tier VPC architectures.

## Project Structure

```
AWS_Terraform_Script/
├── .git/                                   # Git repository
├── .gitignore                              # Git ignore file
├── README.md                               # This file
│
└── 01_Two-Tier_VPC_Creation_Using_Modules/
    ├── envs/                               # Environment-specific configurations
    │   ├── dev/                            # Development environment
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── provider.tf
    │   │   ├── terraform.tfvars
    │   │   └── variables.tf
    │   │
    │   └── prod/                           # Production environment
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── provider.tf
    │       ├── terraform.tfvars
    │       └── variables.tf
    │
    └── modules/                            # Reusable Terraform modules
        └── vpc/                            # VPC module
            ├── eip.tf                      # Elastic IP configuration
            ├── igw.tf                      # Internet Gateway configuration
            ├── nat_igw.tf                  # NAT Gateway configuration
            ├── outputs.tf                  # Module outputs
            ├── route_table.tf              # Route table configuration
            ├── subnets.tf                  # Subnets configuration
            ├── variables.tf                # Module variables
            └── vpc.tf                      # VPC configuration
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS Account with appropriate IAM permissions
- AWS CLI configured with credentials

## Configuration

### AWS Credentials & Environment Variables

Each environment directory (`dev/` and `prod/`) contains a `terraform.tfvars` file where you should configure:

```hcl
main_vpc_aws_region            = "us-east-1"
global_cred_access_key         = "YOUR_AWS_ACCESS_KEY"
global_cred_secret_key         = "YOUR_AWS_SECRET_KEY"
main_vpc_cidr_block            = "192.168.0.0/24"
main_vpc_public_subnet_cidr_1  = "192.168.0.0/26"
main_vpc_public_subnet_cidr_2  = "192.168.0.64/26"
main_vpc_private_subnet_cidr_1 = "192.168.0.128/26"
main_vpc_private_subnet_cidr_2 = "192.168.0.192/26"
availability_zone_1a           = "us-east-1a"
availability_zone_1b           = "us-east-1b"
availability_zone_1c           = "us-east-1c"
availability_zone_1d           = "us-east-1d"
```

**⚠️ Security Note**: Never commit `terraform.tfvars` to version control. Use `.gitignore` to prevent accidental commits.

## Components Created

### Two-Tier VPC Architecture Includes:

- **VPC**: Custom VPC with configurable CIDR block
- **Public Subnets**: 2 public subnets (one per AZ)
- **Private Subnets**: 2 private subnets (one per AZ)
- **Internet Gateway**: For public subnet routing
- **NAT Gateway**: For private subnet internet access
- **Elastic IP**: For NAT Gateway
- **Route Tables**: Separate routing configurations for public and private subnets

## Usage

### Initialize Terraform

Choose your environment and initialize:

```bash
# For Development environment
cd 01_Two-Tier_VPC_Creation_Using_Modules/envs/dev/
terraform init

# For Production environment
cd 01_Two-Tier_VPC_Creation_Using_Modules/envs/prod/
terraform init
```

### Plan Infrastructure

```bash
terraform plan
```

### Apply Configuration

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

## Variables

### Main VPC Configuration

| Variable | Type | Description |
|----------|------|-------------|
| `main_vpc_cidr_block` | string | CIDR block for the VPC (e.g., "192.168.0.0/24") |
| `main_vpc_public_subnet_cidr_1` | string | CIDR block for first public subnet |
| `main_vpc_public_subnet_cidr_2` | string | CIDR block for second public subnet |
| `main_vpc_private_subnet_cidr_1` | string | CIDR block for first private subnet |
| `main_vpc_private_subnet_cidr_2` | string | CIDR block for second private subnet |

### Availability Zones

| Variable | Type | Description |
|----------|------|-------------|
| `availability_zone_1a` | string | First availability zone (e.g., "us-east-1a") |
| `availability_zone_1b` | string | Second availability zone (e.g., "us-east-1b") |
| `availability_zone_1c` | string | Third availability zone (e.g., "us-east-1c") |
| `availability_zone_1d` | string | Fourth availability zone (e.g., "us-east-1d") |

## Outputs

Each module provides outputs that can be referenced:

- VPC ID
- Subnet IDs (public and private)
- Internet Gateway ID
- NAT Gateway ID
- Route Table IDs

## Best Practices

1. **State Management**: Store Terraform state in S3 with DynamoDB locking
2. **Security**: Use IAM roles instead of hardcoded credentials
3. **Modularity**: Keep configurations modular for reusability
4. **Version Control**: Use `.gitignore` to exclude sensitive files
5. **Testing**: Always run `terraform plan` before `terraform apply`

## Troubleshooting

### Variable Reference Errors

Ensure variables are prefixed with `var.` when referencing them in modules:

```hcl
# ✅ Correct
main_vpc_cidr_block = var.main_vpc_cidr_block

# ❌ Incorrect
main_vpc_cidr_block = main_vpc_cidr_block
```

### Terraform Lock Issues

If you encounter lock file issues:

```bash
terraform init -upgrade
```

## Contributing

1. Create a new branch for your changes
2. Test your configurations with `terraform plan`
3. Commit your changes with clear messages
4. Push to your branch and create a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues or questions, please contact the project maintainer or create an issue in the repository.
