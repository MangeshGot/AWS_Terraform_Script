#------------------------------------------------------------------------------
# Staging Environment Variables
#------------------------------------------------------------------------------

variable "vpc_region_name" {
  description = "The AWS region where the VPC will be created."
  type        = string
}

variable "azs" {
  description = "A list of availability zones for the VPC."
  type        = list(string)
}

variable "instance_types" {
  description = "The instance types to use for the EKS node group."
  type        = list(string)
  sensitive   = true
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The list of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "The list of CIDR blocks for private subnets."
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "A map of tags to assign to the public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "A map of tags to assign to the private subnets."
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
}

variable "environment_profile" {
  description = "The AWS profile/environment identifier."
  type        = string
}
