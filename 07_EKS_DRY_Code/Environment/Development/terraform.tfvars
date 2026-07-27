vpc_region_name = "us-east-1"
azs = ["us-east-1a", "us-east-1b"]
vpc_cidr_block = "192.168.0.0/24"
public_subnet_cidr = ["192.168.0.0/26", "192.168.0.64/26"]
private_subnet_cidr = ["192.168.0.128/26", "192.168.0.192/26"]
public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
}
private_subnet_tags = {
    "kubernetes.io/role/node" = "1"
    "kubernetes.io/cluster/EKS-Cluster" = "owned"
}
cluster_name = "EKS-Cluster"

environment_profile = "Development"