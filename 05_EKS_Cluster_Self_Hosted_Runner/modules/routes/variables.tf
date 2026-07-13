variable "environment" {
  description = "Environment name used in route table tags."
  type        = string
}

variable "eks_vpc_id" {
  description = "ID of the VPC where the route tables are created."
  type        = string
}

variable "eks_public_subnet_1_id" {
  description = "The ID of the first public subnet."
  type        = string
}

variable "eks_public_subnet_2_id" {
  description = "The ID of the second public subnet."
  type        = string
}

variable "eks_private_subnet_1_id" {
  description = "The ID of the first private subnet."
  type        = string
}

variable "eks_private_subnet_2_id" {
  description = "The ID of the second private subnet."
  type        = string
}

variable "eks_igw_id" {
  description = "ID of the Internet Gateway attached to the VPC."
  type        = string
}

variable "eks_nat_igw_id" {
  description = "ID of the NAT Gateway used for private subnet routing."
  type        = string
}