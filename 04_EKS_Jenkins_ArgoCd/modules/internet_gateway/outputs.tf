output "eks_igw_id" {
  value = aws_internet_gateway.eks_igw.id
}
output "eks_nat_igw_id" {
  value = aws_nat_gateway.eks_nat_igw.id
}