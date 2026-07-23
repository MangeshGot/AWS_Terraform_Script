module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  environment_profile = var.environment_profile
}

module "subnets" {
  source                = "../../modules/subnets"
  out_vpc_id            = module.vpc.eks_vpc_id
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  AZ_1A                 = var.AZ_1A
  AZ_1B                 = var.AZ_1B
  AZ_1C                 = var.AZ_1C
  AZ_1D                 = var.AZ_1D

}

module "igw" {
  source = "../../modules/igw"
}

module "eks" {
  source = "../../modules/eks"
}
