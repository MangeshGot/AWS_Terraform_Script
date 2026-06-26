variable "eks_vpc_region" {
  description = "AWS region where the EKS networking resources will be created."
  type        = string
}

variable "eks_access_key" {
  description = "AWS access key used by the provider to authenticate."
  type        = string
}

variable "eks_secret_key" {
  description = "AWS secret key used by the provider to authenticate."
  type        = string
}

variable "eks_vpc_cidr_block" {
  description = "CIDR block for the main VPC used by the EKS environment."
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

variable "environment" {
  description = "Deployment environment name such as dev, staging, or production."
  type        = string
}

variable "az_1a" {
  description = "Availability zone for the first subnet."
  type        = string
}

variable "az_1b" {
  description = "Availability zone for the second subnet."
  type        = string
}

variable "az_1c" {
  description = "Availability zone for the third subnet."
  type        = string
}

variable "az_1d" {
  description = "Availability zone for the fourth subnet."
  type        = string
}

variable "cluster_name" {
   type        = string
  description = "Name of the EKS cluster"
}
variable "cluster_version" {
  type        = string
  default     = "1.35"
  description = "Kubernetes version"
}
variable "instance_types" {
  type        = list(string)
  default     = ["m7i-flex.large"]
  description = "EC2 instance types for the worker nodes"
}