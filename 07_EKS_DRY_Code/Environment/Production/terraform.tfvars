#------------------------------------------------------------------------------
# Production Environment Variables Configuration (tfvars)
#------------------------------------------------------------------------------

vpc_region_name     = "us-east-1"
azs                 = ["us-east-1a", "us-east-1b"]
vpc_cidr_block      = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.10.0/24", "10.0.11.0/24"]

# Cluster-specific subnet tags are appended dynamically inside the VPC module
public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
}

private_subnet_tags = {
  "kubernetes.io/role/node" = "1"
}

cluster_name        = "EKS-Production-Cluster"
cluster_version     = "1.36"
instance_types      = ["m7i-flex.large"]
environment_profile = "Production"
