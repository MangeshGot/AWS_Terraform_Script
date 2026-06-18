output "jenkins_controller_public_ip" {
  value = aws_instance.controller_ec2.public_ip
}
output "jenkins_agent_private_ip" {
  value = aws_instance.agent_ec2.private_ip
}