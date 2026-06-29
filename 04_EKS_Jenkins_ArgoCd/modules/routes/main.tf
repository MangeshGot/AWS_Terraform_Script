# Creates public and private route tables and associates them with the EKS subnets.
resource "aws_route_table" "eks_public_rt" {
  vpc_id = var.eks_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.eks_igw_id
  }
  tags = { Name = "${var.environment}-EKS-Public-RT" }
}
resource "aws_route_table" "eks_private_rt" {
  vpc_id = var.eks_vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.eks_nat_igw_id
  }
  tags = { Name = "${var.environment}-EKS-Private-RT" }
}
resource "aws_route_table_association" "eks_public_subnet_1_association" {
  subnet_id      = var.eks_public_subnet_1_id
  route_table_id = aws_route_table.eks_public_rt.id
}
resource "aws_route_table_association" "eks_public_subnet_2_association" {
  subnet_id      = var.eks_public_subnet_2_id
  route_table_id = aws_route_table.eks_public_rt.id
}
resource "aws_route_table_association" "eks_private_subnet_1_association" {
  subnet_id      = var.eks_private_subnet_1_id
  route_table_id = aws_route_table.eks_private_rt.id
}
resource "aws_route_table_association" "eks_private_subnet_2_association" {
  subnet_id      = var.eks_private_subnet_2_id
  route_table_id = aws_route_table.eks_private_rt.id
}