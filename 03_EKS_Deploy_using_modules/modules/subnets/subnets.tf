resource "aws_subnet" "public_subnet_1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.public_subnet_1
  availability_zone = var.az_1a
  tags              = { Name = "${var.environment}-PUBLIC-SUBNET-1" }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.public_subnet_2
  availability_zone = var.az_1b
  tags              = { Name = "${var.environment}-PUBLIC-SUBNET-2" }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnet_1
  availability_zone = var.az_1c
  tags              = { Name = "${var.environment}-PRIVATE-SUBNET-1" }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnet_2
  availability_zone = var.az_1d
  tags              = { Name = "${var.environment}-PRIVATE-SUBNET-2" }
}