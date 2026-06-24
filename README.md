# AWS Terraform Script

This repository contains Terraform scripts for creating AWS infrastructure using Infrastructure as Code (IaC). The main project demonstrates a two-tier Jenkins setup on AWS, where the Jenkins Controller is deployed in a public subnet and the Jenkins Agent is deployed in a private subnet using Terraform modules.

## 📌 Project Overview

The goal of this repository is to automate AWS infrastructure creation using Terraform. It helps DevOps learners and engineers understand how to create reusable Terraform code for AWS services such as VPC, subnets, route tables, Internet Gateway, NAT Gateway, security groups, and EC2 instances.

## 🏗️ Architecture

The Jenkins infrastructure follows a two-tier AWS architecture:

- **AWS VPC** for isolated networking
- **Public Subnet** for Jenkins Controller
- **Private Subnet** for Jenkins Agent
- **Internet Gateway** for public internet access
- **NAT Gateway** for private subnet outbound internet access
- **Security Groups** for controlled traffic
- **EC2 Instances** for Jenkins Controller and Jenkins Agent
- **Terraform Modules** for reusable infrastructure code

## 📂 Repository Structure

```text
AWS_Terraform_Script/
├── 01_Two-Tier_VPC_Creation_Using_Modules/
│   ├── env/
│   │   ├── dev/
│   │   └── prod/
│   ├── modules/
│   │   └── vpc/
│   │       ├── eip.tf
│   │       ├── igw.tf
│   │       ├── nat_igw.tf
│   │       ├── outputs.tf
│   │       ├── route_table.tf
│   │       ├── subnets.tf
│   │       ├── variables.tf
│   │       └── vpc.tf
│   └── README.md
│
├── 02_Jenkins_Controller_Agent_using_Modules/
│   ├── enviroment/
│   │   ├── devlopement/
│   │   └── production/
│   ├── modules/
│   │   └── jenkins_controller_agent/
│   │       ├── eip.tf
│   │       ├── igw.tf
│   │       ├── instance.tf
│   │       ├── nat_igw.tf
│   │       ├── outputs.tf
│   │       ├── route_table.tf
│   │       ├── security_group.tf
│   │       ├── subnets.tf
│   │       ├── variables.tf
│   │       └── vpc.tf
│   └── README.md
│
├── 03_EKS_Deploy_using_modules/
│   ├── enviroment/
│   │   ├── devlopement/
│   │   ├── production/
│   │   └── staging/
│   ├── modules/
│   │   ├── internet_gateway/
│   │   ├── routes/
│   │   ├── subnets/
│   │   └── vpc/
│   └── README.md
│
├── .gitignore
└── README.md
```

> Folder names may vary depending on your latest repository updates.

## 🚀 Features

- AWS infrastructure provisioning using Terraform
- Modular Terraform code structure
- Jenkins Controller and Agent setup
- Public and private subnet architecture
- Secure SSH access between Jenkins Controller and Agent
- NAT Gateway for private instance internet access
- Easy-to-understand DevOps learning project

## 🛠️ Technologies Used

- **Terraform**
- **AWS Cloud**
- **EC2**
- **VPC**
- **Subnets**
- **Internet Gateway**
- **NAT Gateway**
- **Security Groups**
- **Jenkins**

## ✅ Prerequisites

Before using this project, make sure you have:

- AWS Account
- Terraform installed
- AWS CLI installed and configured
- IAM user with required permissions
- SSH key pair created in AWS
- Basic knowledge of AWS and Terraform

## ⚙️ AWS CLI Configuration

Configure AWS CLI before running Terraform:

```bash
aws configure
```

Enter:

```bash
AWS Access Key ID
AWS Secret Access Key
Default region name
Default output format
```

## ▶️ How to Use

### 1. Clone the Repository

```bash
git clone https://github.com/MangeshGot/AWS_Terraform_Script.git
cd AWS_Terraform_Script
```

### 2. Go to the Project Folder

```bash
cd 02_Jenkins_Controller_Agent_using_Modules
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Validate Terraform Code

```bash
terraform validate
```

### 5. Preview Infrastructure Changes

```bash
terraform plan
```

### 6. Create AWS Infrastructure

```bash
terraform apply
```

Type `yes` when Terraform asks for confirmation.

### 7. Destroy Infrastructure

To avoid AWS charges, destroy the resources after testing:

```bash
terraform destroy
```

## 🔐 Security Notes

- Do not upload AWS access keys to GitHub.
- Do not commit `.terraform/`, `terraform.tfstate`, or private key files.
- Use IAM permissions carefully.
- Restrict SSH access to your own IP address where possible.

## 📌 Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## 📖 Learning Outcomes

After completing this project, you will understand:

- How Terraform creates AWS infrastructure
- How to use Terraform modules
- How public and private subnets work
- How Jenkins Controller and Agent architecture works
- How NAT Gateway provides internet access to private instances
- How security groups control inbound and outbound traffic

## 🧹 Recommended `.gitignore`

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
crash.log
crash.*.log
*.pem
.terraform.lock.hcl
```

> If you want to share sample variables, use `terraform.tfvars.example` instead of uploading real `terraform.tfvars`.

## 👨‍💻 Author

**Mangesh Sonawane**  
GitHub: [MangeshGot](https://github.com/MangeshGot)

## ⭐ Support

If this project helps you, give it a ⭐ on GitHub.

## 📜 License

This project is for learning and educational purposes.