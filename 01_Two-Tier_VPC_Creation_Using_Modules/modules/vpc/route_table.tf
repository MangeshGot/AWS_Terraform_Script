resource "aws_route_table" "main_vpc_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "${var.environment}-PUBLIC-ROUTE-TABLE" }
}
resource "aws_route_table" "main_vpc_private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "${var.environment}-PRIVATE-ROUTE-TABLE" }
}
resource "aws_route_table_association" "main_vpc_public_subnet_1_association" {
  subnet_id      = aws_subnet.main_vpc_public_subnet_1.id
  route_table_id = aws_route_table.main_vpc_public_route_table.id
}
resource "aws_route_table_association" "main_vpc_public_subnet_2_association" {
  subnet_id      = aws_subnet.main_vpc_public_subnet_2.id
  route_table_id = aws_route_table.main_vpc_public_route_table.id
}
resource "aws_route_table_association" "main_vpc_private_subnet_1_association" {
  subnet_id      = aws_subnet.main_vpc_private_subnet_1.id
  route_table_id = aws_route_table.main_vpc_private_route_table.id
}
resource "aws_route_table_association" "main_vpc_private_subnet_2_association" {
  subnet_id      = aws_subnet.main_vpc_private_subnet_2.id
  route_table_id = aws_route_table.main_vpc_private_route_table.id
}