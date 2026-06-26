output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "The name of the provisioned EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "The endpoint for the EKS Kubernetes API server"
}
