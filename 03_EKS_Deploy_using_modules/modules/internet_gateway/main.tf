resource "aws_internet_gateway" "eks_igw"{
    vpc_id=var.eks_vpc_id
    tags={Name="${var.environment}-EKS-IGW"}
}
resource "aws_eip" "eks_nat_igw_eip" {
  tags = { Name = "${var.environment}-EKS-IGW-EIP" }
}
resource "aws_nat_gateway" "eks_nat_igw" {
  allocation_id = aws_eip.eks_nat_igw_eip.id
  subnet_id     = var.eks_public_subnet_1_id #IMPORTANT!! To Be Created in Public Subnet Only
  tags = { Name = "${var.environment}-EKS-IGW" }
}