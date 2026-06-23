resource "aws_subnet" "eks_public_subnet_1"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_public_subnet_1
    availability_zone= var.az_1a
}
resource "aws_subnet" "eks_public_subnet_2"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_public_subnet_2
    availability_zone= var.az_1b
}
resource "aws_subnet" "eks_private_subnet_1"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_private_subnet_1
    availability_zone= var.az_1c
}
resource "aws_subnet" "eks_private_subnet_2"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_private_subnet_2
    availability_zone= var.az_1d
}