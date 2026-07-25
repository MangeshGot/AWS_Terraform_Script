variable "environment_profile" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "alb_service_account_name" {
  type = string
}
variable "alb_namespace" {
  type = string
}
variable "instance_types" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
