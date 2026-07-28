#------------------------------------------------------------------------------
# Production Environment Root Module
#------------------------------------------------------------------------------

module "vpc" {
  source              = "../../modules/vpc"
  vpc_region_name     = var.vpc_region_name
  vpc_cidr_block      = var.vpc_cidr_block
  environment_profile = var.environment_profile
  azs                 = var.azs
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
  cluster_name        = var.cluster_name
}

module "eks" {
  source              = "../../modules/eks"
  instance_types      = var.instance_types
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  private_subnets_ids = module.vpc.private_subnets_ids
  environment_profile = var.environment_profile
}
