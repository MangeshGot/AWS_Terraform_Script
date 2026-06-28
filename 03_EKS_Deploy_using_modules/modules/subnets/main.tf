# Creates the public and private subnets required for the EKS network layout.
resource "aws_subnet" "eks_public_subnet_1"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_public_subnet_1
    availability_zone= var.az_1a
    tags ={
        Name="${var.environment}-Public-Subnet-1"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
        }
}
resource "aws_subnet" "eks_public_subnet_2"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_public_subnet_2
    availability_zone= var.az_1b
    tags ={
        Name="${var.environment}-Public-Subnet-2"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
        }
}
resource "aws_subnet" "eks_private_subnet_1"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_private_subnet_1
    availability_zone= var.az_1c
    tags ={
        Name="${var.environment}-Private-Subnet-1"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
    }
}
resource "aws_subnet" "eks_private_subnet_2"{
    vpc_id =var.eks_vpc_id
    cidr_block=var.eks_private_subnet_2
    availability_zone= var.az_1d
    tags ={
        Name="${var.environment}-Private-Subnet-2"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
        }
}