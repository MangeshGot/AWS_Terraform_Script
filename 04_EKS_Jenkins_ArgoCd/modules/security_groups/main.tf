resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkin-SG"
  description = "Allow all inbound HTTP and outbound traffic"
  vpc_id      = var.eks_vpc_id
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP traffic on port 8080"
  }
  ingress {
    description = "Allow inbound SSH traffic on port 22"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ICMP (Ping) from within the VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.environment}-JENKINS-SG" }
}