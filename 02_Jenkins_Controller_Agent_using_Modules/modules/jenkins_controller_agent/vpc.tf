resource "aws_vpc" "vpc_main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags             = { Name = "${var.enviroment}-MAIN-VPC" }
}