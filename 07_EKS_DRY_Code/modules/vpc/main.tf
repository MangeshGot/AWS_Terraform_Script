#--------------VPC Creation----------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.environment_profile}-VPC"
  }
}

#--------------Public Subnet Creation----------------
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.environment_profile}-Public-Subnet-${count.index + 1}"
    }, var.public_subnet_tags
  )
}

#--------------Private Subnet Creation----------------
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      Name = "${var.environment_profile}-Private-Subnet-${count.index + 1}"
    }, var.private_subnet_tags
  )
}

#--------------Internet Gateway Creation----------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.environment_profile}-Internet-Gateway"
  }
}

#--------------NAT Gateway Creation----------------
resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    Name = "${var.environment_profile}-EIP"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.environment_profile}-NAT-Gateway"
  }
}

#--------------Route Table Creation----------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.environment_profile}-Public-Route-Table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.environment_profile}-Private-Route-Table"
  }
}

#--------------Route Table Association----------------
resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}