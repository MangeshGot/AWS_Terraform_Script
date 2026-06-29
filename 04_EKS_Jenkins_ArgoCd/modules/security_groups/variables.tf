variable "environment" {
  type = string
}
variable "http_port" {
  type = number
}
variable "ssh_port" {
  type = number
}
variable "eks_public_subnet_1_id" {
  type = string
}
variable "eks_vpc_id" {
  description = "VPC ID where the internet gateway will be attached."
  type        = string
}
