variable "cluster_name" {
   type        = string
  description = "Name of the EKS cluster"
}
variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
}
variable "eks_vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
  type        = string
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for worker nodes"
}

variable "instance_types" {
  type        = list(string)
  default     = ["m7i-flex.large"]
  description = "EC2 instance types for the worker nodes"
}
variable "environment" {
  description = "Deployment environment name such as dev, staging, or production."
  type        = string
}
