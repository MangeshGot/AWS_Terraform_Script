#------------------------------------------------------------------------------
# Staging Environment Outputs
#------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "The IDs of the public subnets."
  value       = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  description = "The IDs of the private subnets."
  value       = module.vpc.private_subnets_ids
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "The security group ID associated with the EKS cluster."
  value       = module.eks.cluster_security_group_id
}
