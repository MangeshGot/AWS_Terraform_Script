module "vpc" {
  source             = "../../modules/vpc"
  eks_vpc_cidr_block = var.eks_vpc_cidr_block
  environment        = var.environment
}
module "subnets" {
  source               = "../../modules/subnets"
  eks_vpc_id           = module.vpc.eks_vpc_id
  eks_public_subnet_1  = var.eks_public_subnet_1
  eks_public_subnet_2  = var.eks_public_subnet_2
  eks_private_subnet_1 = var.eks_private_subnet_1
  eks_private_subnet_2 = var.eks_private_subnet_2
  az_1a                = var.az_1a
  az_1b                = var.az_1b
  az_1c                = var.az_1c
  az_1d                = var.az_1d
  environment          = var.environment
  cluster_name         = var.cluster_name
}
module "internet_gateway" {
  source                 = "../../modules/internet_gateway"
  eks_vpc_id             = module.vpc.eks_vpc_id
  environment            = var.environment
  eks_public_subnet_1_id = module.subnets.eks_public_subnet_1_id
}
module "routes" {
  source                  = "../../modules/routes"
  eks_vpc_id              = module.vpc.eks_vpc_id
  eks_public_subnet_1_id  = module.subnets.eks_public_subnet_1_id
  eks_public_subnet_2_id  = module.subnets.eks_public_subnet_2_id
  eks_private_subnet_1_id = module.subnets.eks_private_subnet_1_id
  eks_private_subnet_2_id = module.subnets.eks_private_subnet_2_id
  environment             = var.environment
  eks_igw_id              = module.internet_gateway.eks_igw_id
  eks_nat_igw_id          = module.internet_gateway.eks_nat_igw_id

}
module "eks" {
  source          = "../../modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  eks_vpc_id      = module.vpc.eks_vpc_id
  instance_types  = ["m7i-flex.large"]
  private_subnet_ids = [
    module.subnets.eks_private_subnet_1_id,
    module.subnets.eks_private_subnet_2_id
  ]
  environment = var.environment
}

module "security_groups" {
  source                 = "../../modules/security_groups"
  http_port              = var.http_port
  ssh_port               = var.ssh_port
  environment            = var.environment
  eks_public_subnet_1_id = module.subnets.eks_public_subnet_1_id
  eks_vpc_id             = module.vpc.eks_vpc_id
}

module "instance" {
  source                 = "../../modules/instance"
  eks_public_subnet_1_id = module.subnets.eks_public_subnet_1_id
  environment            = var.environment
  jenkins_sg_id          = [module.security_groups.jenkins_sg_id]
  key_pair_name          = var.key_pair_name
  ami_id                 = var.ami_id
  ec2_instance_type      = var.ec2_instance_type
}
