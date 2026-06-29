# Creates the main VPC used by the EKS environment and enables DNS support.
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.environment}-EKS-VPC" }
}