module "remote_state_s3" {
  source      = "../../modules/remote_state_s3"
  bucket_name = var.bucket_name
}
module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  environment_profile = var.environment_profile
}

module "subnets" {
  source                = "../../modules/subnets"
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  AZ_1A                 = var.AZ_1A
  AZ_1B                 = var.AZ_1B
  AZ_1C                 = var.AZ_1C
  AZ_1D                 = var.AZ_1D
  eks_vpc_id            = module.vpc.eks_vpc_id
  environment_profile   = var.environment_profile
}

module "igw" {
  source              = "../../modules/igw"
  public_subnet_1_id  = module.subnets.eks_public_subnet_1_id
  eks_vpc_id          = module.vpc.eks_vpc_id
  environment_profile = var.environment_profile
}

module "routes" {
  source                  = "../../modules/routes"
  eks_vpc_id              = module.vpc.eks_vpc_id
  eks_igw_id              = module.igw.eks_igw_id
  eks_nat_igw_id          = module.igw.eks_nat_igw_id
  eks_public_subnet_1_id  = module.subnets.eks_public_subnet_1_id
  eks_public_subnet_2_id  = module.subnets.eks_public_subnet_2_id
  eks_private_subnet_1_id = module.subnets.eks_private_subnet_1_id
  eks_private_subnet_2_id = module.subnets.eks_private_subnet_2_id
  environment_profile     = var.environment_profile
}

module "eks" {
  source                   = "../../modules/eks"
  cluster_name             = var.cluster_name
  cluster_version          = var.cluster_version
  alb_service_account_name = var.alb_service_account_name
  alb_namespace            = var.alb_namespace
  instance_types           = var.instance_types
  private_subnet_ids = [
    module.subnets.eks_private_subnet_1_id,
    module.subnets.eks_private_subnet_2_id
  ]
  environment_profile = var.environment_profile
}
