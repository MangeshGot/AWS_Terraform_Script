# Configure the AWS provider for the EKS networking deployment.
provider "aws" {
  region     = var.eks_vpc_region
  access_key = var.eks_access_key
  secret_key = var.eks_secret_key
}