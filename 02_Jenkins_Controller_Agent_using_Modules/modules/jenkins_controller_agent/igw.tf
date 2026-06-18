resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_main.id
  tags   = { Name = "${var.enviroment}-VPC_IGW" }
}