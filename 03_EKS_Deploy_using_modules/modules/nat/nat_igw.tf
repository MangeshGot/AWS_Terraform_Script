resource "aws_nat_gateway" "_nat_igw" {
  allocation_id=aws_eip.nat_eip.id
  subnet_id=module.subnets.public_subnet_1_id #IMPORTANT: NAT Gateway must be created in a public subnet
  tags = {Name="${var.environment}-NAT-IGW"}
}