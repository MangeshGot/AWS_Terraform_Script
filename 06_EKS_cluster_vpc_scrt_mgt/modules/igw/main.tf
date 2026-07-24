resource "aws_internet_gateway" "eks_igw" {
  vpc_id = var.eks_vpc_id
  tags = {
    Name = "${var.environment_profile}_eks_igw"
  }
}
resource "aws_eip" "eks_eip" {
  tags = {
    Name = "${var.environment_profile}_eks_eip"
  }
}

resource "aws_nat_gateway" "eks_nat_gateway" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = var.public_subnet_1_id
  tags = {
    Name = "${var.environment_profile}_eks_eip"
  }
}
