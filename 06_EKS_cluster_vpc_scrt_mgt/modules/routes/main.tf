resource "aws_route_table" "eks_public_rt" {
  vpc_id = var.eks_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.eks_igw_id
  }
  tags = {
    Name = "${var.environment_profile}-EKS_Public-RT"
  }
}

resource "aws_route_table" "eks_public_rt" {
  vpc_id = var.eks_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.eks_nat_igw_id
  }
  tags = {
    Name = "${var.environment_profile}-EKS_Private-RT"
  }
}

resource "aws_route_table_association" "eks_pub_sub_1_assoc" {
  subnet_id      = var.eks_public_subnet_1_id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_pub_sub_2_assoc" {
  subnet_id      = var.eks_public_subnet_2_id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_pvt_sub_1_assoc" {
  subnet_id      = var.eks_private_subnet_1_id
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "eks_pvt_sub_2_assoc" {
  subnet_id      = var.eks_private_subnet_2_id
  route_table_id = aws_route_table.eks_private_rt.id
}
