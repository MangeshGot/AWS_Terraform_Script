#=====================ELASTIC IP========================
resource "aws_eip" "main_vpc_nat_eip" {
  tags = { Name = "MAIN-VPC-NAT-EIP" }
}