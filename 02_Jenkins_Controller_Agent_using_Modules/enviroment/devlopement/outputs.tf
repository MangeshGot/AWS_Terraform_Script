output "jenkins_controller_public_ip" {
  value = module.jenkins_controller_agent.jenkins_controller_public_ip
}
output "jenkins_agent_private_ip" {
  value = module.jenkins_controller_agent.jenkins_agent_private_ip
}