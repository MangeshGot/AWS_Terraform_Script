#=====================MAIN VPC========================
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.main_vpc_cidr_block
  instance_tenancy = "default"
  tags = { Name = "Default-VPC" }
}
