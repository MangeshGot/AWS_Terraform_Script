variable "vpc_region_name" {
  type        = string
  description = "AWS region name"
}
variable "vpc_cidr_block" {
  type = string
}
variable "public_subnet_1_cidr" {
  type = string
}
variable "public_subnet_2_cidr" {
  type = string
}
variable "private_subnet_1_cidr" {
  type = string
}
variable "private_subnet_2_cidr" {
  type = string
}
variable "AZ_1A" {
  type = string
}
variable "AZ_1B" {
  type = string
}
variable "AZ_1C" {
  type = string
}
variable "AZ_1D" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "environment_profile" {
  type = string
}
