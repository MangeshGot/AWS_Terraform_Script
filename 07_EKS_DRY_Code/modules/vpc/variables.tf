#------------------------------------------------------------------------------
# VPC Module Variables
#------------------------------------------------------------------------------

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnets."
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones for the VPC."
  type        = list(string)
}

variable "vpc_region_name" {
  description = "The AWS region where the VPC will be created."
  type        = string
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

variable "environment_profile" {
  description = "The AWS profile/environment identifier."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster for resource tagging."
  type        = string
  default     = ""
}
