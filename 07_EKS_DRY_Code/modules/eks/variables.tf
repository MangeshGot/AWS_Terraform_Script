variable "instance_types" {
  type = list(string)
}
variable "private_subnets_ids" {
  type = list(string)
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
