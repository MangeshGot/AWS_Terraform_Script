#------------------------------------------------------------------------------
# EKS Module Outputs
#------------------------------------------------------------------------------

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "The security group ID associated with the EKS cluster."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
