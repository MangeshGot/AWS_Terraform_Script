output "eks_public_subnet_1_id" {
  value = aws_subnet.eks_public_subnet_1.id
}
output "eks_public_subnet_2_id" {
  value = aws_subnet.eks_public_subnet_2.id
}
output "eks_private_subnet_1_id" {
  value = aws_subnet.eks_private_subnet_1.id
}
output "eks_private_subnet_2_id" {
  value = aws_subnet.eks_private_subnet_2.id
}