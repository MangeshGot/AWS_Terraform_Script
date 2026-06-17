variable "main_vpc_aws_region" {
  type = string
}
variable "main_vpc_cidr_block" {
  type = string
}
variable "global_cred_access_key" {
  type = string
}
variable "global_cred_secret_key" {
  type = string
}
variable "main_vpc_public_subnet_cidr_1" {
  type = string
}
variable "main_vpc_public_subnet_cidr_2" {
  type = string
}
variable "main_vpc_private_subnet_cidr_1" {
  type = string
}
variable "main_vpc_private_subnet_cidr_2" {
  type = string
}
variable "availability_zone_1a" {
  type = string
}
variable "availability_zone_1b" {
  type = string
}
variable "availability_zone_1c" {
  type = string
}
variable "availability_zone_1d" {
  type = string
}
#To give the environment name to the module, so that it can be used in naming resources
variable "environment" {
  type = string
}