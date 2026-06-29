resource "aws_instance" "controller_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  subnet_id                   = var.eks_public_subnet_1_id
  vpc_security_group_ids      = var.jenkins_sg_id
  user_data                   = <<-EOF
                 #!/bin/bash
                sudo apt update -y
                sudo apt install fontconfig openjdk-21-jre -y
                sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
                https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
                echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt update -y
                sudo apt install jenkins -y
                sudo systemctl enable jenkins
                sudo systemctl start jenkins
                EOF
  tags                        = { Name = "${var.environment}-Jenkins-Controller" }
}
resource "aws_instance" "agent_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  subnet_id                   = var.eks_public_subnet_1_id
  vpc_security_group_ids      = var.jenkins_sg_id
  user_data                   = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install fontconfig openjdk-21-jre -y
                EOF
  tags                        = { Name = "${var.environment}-Jenkins-Agent" }

}