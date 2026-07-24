output "eks_igw_id" {
  value       = aws_internte_gateway.eks_igw.id
  description = "Its give IGW ID"
}
output "eks_nat_igw_id" {
  value = aws_nat_gateway.eks_nat_igw.id
}
