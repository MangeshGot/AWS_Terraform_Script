variable "eks_vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
  type        = string
}

variable "eks_public_subnet_1" {
  description = "CIDR block for the first public subnet."
  type        = string
}

variable "eks_public_subnet_2" {
  description = "CIDR block for the second public subnet."
  type        = string
}

variable "eks_private_subnet_1" {
  description = "CIDR block for the first private subnet."
  type        = string
}

variable "eks_private_subnet_2" {
  description = "CIDR block for the second private subnet."
  type        = string
}

variable "az_1a" {
  description = "Availability zone for the first public subnet."
  type        = string
}

variable "az_1b" {
  description = "Availability zone for the second public subnet."
  type        = string
}

variable "az_1c" {
  description = "Availability zone for the first private subnet."
  type        = string
}

variable "az_1d" {
  description = "Availability zone for the second private subnet."
  type        = string
}
variable "environment" {
  description = "Deployment environment name such as dev, staging, or production."
  type        = string
}