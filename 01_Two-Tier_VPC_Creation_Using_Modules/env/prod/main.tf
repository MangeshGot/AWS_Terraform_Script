module "vpc" {
  source                         = "../../modules/vpc"
  main_vpc_aws_region            = var.main_vpc_aws_region
  main_vpc_cidr_block            = var.main_vpc_cidr_block
  global_cred_access_key         = var.global_cred_access_key
  global_cred_secret_key         = var.global_cred_secret_key
  main_vpc_public_subnet_cidr_1  = var.main_vpc_public_subnet_cidr_1
  main_vpc_public_subnet_cidr_2  = var.main_vpc_public_subnet_cidr_2
  main_vpc_private_subnet_cidr_1 = var.main_vpc_private_subnet_cidr_1
  main_vpc_private_subnet_cidr_2 = var.main_vpc_private_subnet_cidr_2
  availability_zone_1a           = var.availability_zone_1a
  availability_zone_1b           = var.availability_zone_1b
  availability_zone_1c           = var.availability_zone_1c
  availability_zone_1d           = var.availability_zone_1d
  environment                    = var.environment
}