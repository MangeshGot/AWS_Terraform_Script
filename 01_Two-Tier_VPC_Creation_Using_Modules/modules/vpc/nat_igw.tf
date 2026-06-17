#=====================NAT INTERNET GATEWAY========================
resource "aws_nat_gateway" "main_vpc_nat_igw" {
  allocation_id = aws_eip.main_vpc_nat_eip.id
  subnet_id     = aws_subnet.main_vpc_public_subnet_1.id #IMPORTANT!! To Be Created in Public Subnet Only
}