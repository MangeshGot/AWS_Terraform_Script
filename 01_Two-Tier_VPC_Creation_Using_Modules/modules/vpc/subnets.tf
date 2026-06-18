#=====================MAIN VPC SUBNETS========================
resource "aws_subnet" "main_vpc_public_subnet_1" {
  vpc_id           = aws_vpc.main_vpc.id
  cidr_block       = var.main_vpc_public_subnet_cidr_1
  availability_zone = var.availability_zone_1a
  tags             = { Name = "${var.environment}-MAIN-VPC-PUBLIC-SUBNET-1" }
}
resource "aws_subnet" "main_vpc_public_subnet_2" {
  vpc_id           = aws_vpc.main_vpc.id
  cidr_block       = var.main_vpc_public_subnet_cidr_2
  availability_zone = var.availability_zone_1b
  tags             = { Name = "${var.environment}-MAIN-VPC-PUBLIC-SUBNET-2" }
}
resource "aws_subnet" "main_vpc_private_subnet_1" {
  vpc_id           = aws_vpc.main_vpc.id
  cidr_block       = var.main_vpc_private_subnet_cidr_1
  availability_zone = var.availability_zone_1c
  tags             = { Name = "${var.environment}-MAIN-VPC-PRIVATE-SUBNET-1" }
}
resource "aws_subnet" "main_vpc_private_subnet_2" {
  vpc_id           = aws_vpc.main_vpc.id
  cidr_block       = var.main_vpc_private_subnet_cidr_2
  availability_zone = var.availability_zone_1d
  tags             = { Name = "${var.environment}-MAIN-VPC-PRIVATE-SUBNET-2" }
}