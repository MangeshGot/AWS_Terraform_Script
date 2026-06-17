output "nat_public_ip" {
  value = aws_eip.main_vpc_nat_eip.public_ip
  description = "Public IP address of the NAT Gateway in the Main VPC"
}