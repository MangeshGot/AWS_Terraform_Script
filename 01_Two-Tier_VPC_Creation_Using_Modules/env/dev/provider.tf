provider "aws" {
  region     = var.main_vpc_aws_region
  access_key = var.global_cred_access_key
  secret_key = var.global_cred_secret_key
}