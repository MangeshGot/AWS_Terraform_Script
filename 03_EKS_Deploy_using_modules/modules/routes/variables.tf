variable "environment" {
  type=string
}
variable "eks_vpc_id" {
    type=string
}
variable "eks_public_subnet_1_id" {
  description = "The ID of the first public subnet"
  type        = string
}
variable "eks_public_subnet_2_id" {
  description = "The ID of the second public subnet"
  type        = string
}
variable "eks_private_subnet_1_id" {
  description = "The ID of the first private subnet"
  type        = string
}
variable "eks_private_subnet_2_id" {
  description = "The ID of the second private subnet"
  type        = string
}
variable "eks_igw_id" {
    type=string
}
variable "eks_nat_igw_id" {
    type=string
}