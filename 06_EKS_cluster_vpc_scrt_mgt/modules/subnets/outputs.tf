output "eks_public_subnet_1_id" {
  value = aws_subnet.this_public_subnet1.id
}
output "eks_public_subnet_2_id" {
  value = aws_subnet.this_public_subnet2.id
}
output "eks_private_subnet_1_id" {
  value = aws_subnet.this_private_subnet1.id
}
output "eks_private_subnet_2_id" {
  value = aws_subnet.this_private_subnet2.id
}
