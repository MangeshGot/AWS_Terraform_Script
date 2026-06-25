variable "eks_vpc_cidr_block" {
  description = "CIDR block to assign to the VPC for the EKS environment."
  type        = string
}

variable "environment" {
  description = "Name of the deployment environment such as dev or prod."
  type        = string
}
