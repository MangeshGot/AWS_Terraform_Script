resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.public_subnet_1
  availability_zone = var.az_1a
  tags              = { Name = "${var.enviroment}-PUBLIC-SUBNET-1" }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.public_subnet_2
  availability_zone = var.az_1b
  tags              = { Name = "${var.enviroment}-PUBLIC-SUBNET-2" }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_1
  availability_zone = var.az_1c
  tags              = { Name = "${var.enviroment}-PRIVATE-SUBNET-1" }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_2
  tags              = { Name = "${var.enviroment}-PRIVATE-SUBNET-2" }
  availability_zone = var.az_1d
}