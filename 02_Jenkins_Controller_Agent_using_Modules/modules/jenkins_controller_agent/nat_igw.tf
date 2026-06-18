resource "aws_nat_gateway" "nat_igw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id # IMPORTANT!!! ALWAYS CREATE IT INTO PUBLIC SUBNET
  tags          = { Name = "${var.enviroment}-NAT-GATEWAY" }
}