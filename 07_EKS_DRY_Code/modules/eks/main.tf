#------------------------------------------------------------------------------
# Control Plane IAM Role
#------------------------------------------------------------------------------
resource "aws_iam_role" "cluster_control_plane_role" {
  name = "${var.environment_profile}-${var.cluster_name}-CONTROL-PLANE-ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

#------------------------------------------------------------------------------
# Attach Policies to Control Plane Role
#------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "cluster_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ])

  policy_arn = each.value
  role       = aws_iam_role.cluster_control_plane_role.name
}

#------------------------------------------------------------------------------
# EKS Cluster
#------------------------------------------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster_control_plane_role.arn

  vpc_config {
    subnet_ids              = var.private_subnets_ids
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policies
  ]
}

#------------------------------------------------------------------------------
# EKS Node Group IAM Role
#------------------------------------------------------------------------------
resource "aws_iam_role" "cluster_node_group_role" {
  name = "${var.environment_profile}-${var.cluster_name}-NODEGROUP-ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

#------------------------------------------------------------------------------
# Attach Policies to Node Group Role
#------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.cluster_node_group_role.name
}

#------------------------------------------------------------------------------
# EKS Node Group
#------------------------------------------------------------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-m7i-flex-workers"
  node_role_arn   = aws_iam_role.cluster_node_group_role.arn
  subnet_ids      = var.private_subnets_ids
  instance_types  = var.instance_types
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Environment = var.environment_profile
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policies
  ]
}

#------------------------------------------------------------------------------
# EKS Addons (VPC CNI, kube-proxy, CoreDNS)
#------------------------------------------------------------------------------
resource "aws_eks_addon" "addons" {
  for_each     = toset(["vpc-cni", "kube-proxy", "coredns"])
  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.value

  depends_on = [aws_eks_node_group.this]
}