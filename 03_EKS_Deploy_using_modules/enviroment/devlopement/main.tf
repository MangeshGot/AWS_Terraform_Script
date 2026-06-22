module "igw" {
  source      = "../../modules/igw"
  environment = var.environment
}
module "route_tables" {
  source      = "../../modules/route_tables"
  environment = var.environment
}
module "subnets" {
  source           = "../../modules/subnets"
  public_subnet_1  = var.public_subnet_1
  public_subnet_2  = var.public_subnet_2
  private_subnet_1 = var.private_subnet_1
  private_subnet_2 = var.private_subnet_2
  az_1a            = var.az_1a
  az_1b            = var.az_1b
  az_1c            = var.az_1c
  az_1d            = var.az_1d
  environment      = var.environment
}
module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}