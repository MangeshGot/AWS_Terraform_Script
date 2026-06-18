resource "aws_eip" "nat_eip" {
  tags = { Name = "${var.enviroment}-NAT_EIP" }
}