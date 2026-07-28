#------------------------------------------------------------------------------
# Staging Environment Variables Configuration (tfvars)
#------------------------------------------------------------------------------

vpc_region_name     = "us-east-1"
azs                 = ["us-east-1a", "us-east-1b"]
vpc_cidr_block      = "192.168.1.0/24"
public_subnet_cidr  = ["192.168.1.0/26", "192.168.1.64/26"]
private_subnet_cidr = ["192.168.1.128/26", "192.168.1.192/26"]

# Cluster-specific subnet tags are appended dynamically inside the VPC module
public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
}

private_subnet_tags = {
  "kubernetes.io/role/node" = "1"
}

cluster_name        = "EKS-Staging-Cluster"
cluster_version     = "1.36"
instance_types      = ["m7i-flex.large"]
environment_profile = "Staging"
