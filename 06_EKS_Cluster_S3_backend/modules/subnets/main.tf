resource "aws_subnet" "this_public_subnet1" {
  vpc_id            = var.eks_vpc_id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.AZ_1A
  tags = {
    Name                                               = "${var.environment_profile}-public-subnet-1"
    "kubernetes.io/role/elb"                           = "1"
    "kubernetes.io/cluster/${var.environment_profile}" = "owned"
  }
}

resource "aws_subnet" "this_public_subnet2" {
  vpc_id            = var.eks_vpc_id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.AZ_1B
  tags = {
    Name                                               = "${var.environment_profile}-public-subnet-2"
    "kubernetes.io/role/elb"                           = "1"
    "kubernetes.io/cluster/${var.environment_profile}" = "owned"
  }
}


resource "aws_subnet" "this_private_subnet1" {
  vpc_id            = var.eks_vpc_id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.AZ_1A
  tags = {
    Name                                               = "${var.environment_profile}-private-subnet-1"
    "kubernetes.io/role/internal-elb"                  = "1"
    "kubernetes.io/cluster/${var.environment_profile}" = "owned"
  }
}


resource "aws_subnet" "this_private_subnet2" {
  vpc_id            = var.eks_vpc_id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.AZ_1B
  tags = {
    Name                                               = "${var.environment_profile}-private-subnet-2"
    "kubernetes.io/role/internal-elb"                  = "1"
    "kubernetes.io/cluster/${var.environment_profile}" = "owned"
  }
}
