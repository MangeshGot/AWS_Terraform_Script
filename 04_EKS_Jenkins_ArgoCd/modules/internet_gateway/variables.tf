variable "environment" {
  description = "Environment name used in resource tags."
  type        = string
}

variable "eks_vpc_id" {
  description = "VPC ID where the internet gateway will be attached."
  type        = string
}

variable "eks_public_subnet_1_id" {
  description = "ID of the public subnet used for the NAT gateway."
  type        = string
}
