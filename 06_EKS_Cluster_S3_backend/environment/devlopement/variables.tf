variable "vpc_region_name" {
  type        = string
  description = "AWS region name"
  sensitive   = true
}
variable "vpc_cidr_block" {
  type      = string
  sensitive = true
}
variable "public_subnet_1_cidr" {
  type      = string
  sensitive = true
}
variable "public_subnet_2_cidr" {
  type      = string
  sensitive = true
}
variable "private_subnet_1_cidr" {
  type      = string
  sensitive = true
}
variable "private_subnet_2_cidr" {
  type      = string
  sensitive = true
}
variable "AZ_1A" {
  type      = string
  sensitive = true
}
variable "AZ_1B" {
  type      = string
  sensitive = true
}
variable "AZ_1C" {
  type      = string
  sensitive = true
}
variable "AZ_1D" {
  type      = string
  sensitive = true
}
variable "cluster_name" {
  type      = string
  sensitive = true
}
variable "cluster_version" {
  type      = string
  sensitive = true
}
variable "alb_service_account_name" {
  type      = string
  sensitive = true
}
variable "alb_namespace" {
  type      = string
  sensitive = true
}
variable "instance_types" {
  type      = list(string)
  sensitive = true
}
variable "bucket_name" {
  type      = string
  sensitive = true
}
variable "environment_profile" {
  type      = string
  sensitive = true
}
