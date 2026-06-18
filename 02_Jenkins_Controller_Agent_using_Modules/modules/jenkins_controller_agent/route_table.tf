resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main.id
  tags   = { Name = "${var.enviroment}-PUBLIC_RT" }

}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id
  tags   = { Name = "${var.enviroment}-PRIVATE_RT" }
}
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}