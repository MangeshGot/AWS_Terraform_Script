variable "ec2_instance_type" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "key_pair_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "eks_public_subnet_1_id" {
  type = string
}
variable "jenkins_sg_id" {
  description = "List of Security Group IDs for the instance"
  type        = list(string)
}
