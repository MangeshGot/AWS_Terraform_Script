resource "aws_nat_gateway" "_nat_igw" {
  allocation_id=aws_eip.nat_eip.id
  subnet_id=aws_subnet.public_subnet_1.id #IMPORTANT: NAT Gateway must be created in a public subnet
  tags = {Name="${var.environment}-NAT-IGW"}
}