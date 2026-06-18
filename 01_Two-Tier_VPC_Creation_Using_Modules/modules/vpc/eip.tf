#=====================ELASTIC IP========================
resource "aws_eip" "main_vpc_nat_eip" {
  tags = { Name = "${var.environment}-MAIN-VPC-NAT-EIP" }
}