#----------------IAM Role for Control Plane----------------
resource "aws_iam_role" "eks_cluster_iam_role" {
  name = "${var.environment_profile}-${var.cluster_name}-control-plane-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}
#---------------- Attach Policy to Control Plane Role ----------------
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}
#----------------EKS Cluster Creation----------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_iam_role.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}
#----------------IAM Role for EBS Storage----------------
resource "aws_iam_role" "ebs_csi_role" {
  name = "${var.environment_profile}-${var.cluster_name}-ebs-csi-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

#---------------- Attach Policy to EBS CSI Role ----------------
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role.name
}
#----------------EBS CSI Pod Identity Association----------------
resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_role.arn
}
#----------------VPC CNI Addon----------------
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  depends_on   = [aws_iam_role_policy_attachment.ebs_csi_policy]
}
#----------------CoreDNS Addon----------------
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
  depends_on   = [aws_eks_node_group.this]
}
#----------------Kube Proxy Addon----------------
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}
#----------------EBS CSI Addon----------------
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.this,
    aws_eks_addon.pod_identity,
    aws_eks_pod_identity_association.ebs_csi
  ]
}
#----------------IAM Role for Node Group----------------
resource "aws_iam_role" "cluster_nodegroup_role" {
  name = "${var.environment_profile}-${var.cluster_name}-nodegroup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}
#---------------- Attach Policy to Node Group Role ----------------
resource "aws_iam_role_policy_attachment" "node_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cluster_nodegroup_role.name
}
#---------------- Attach Policy to Node Group Role ----------------
resource "aws_iam_role_policy_attachment" "node_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cluster_nodegroup_role.name
}
#---------------- Attach Policy to Node Group Role ----------------
resource "aws_iam_role_policy_attachment" "node_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cluster_nodegroup_role.name
}
#---------------- Managed Node Group ----------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-m7i-flex-workers"
  node_role_arn   = aws_iam_role.cluster_nodegroup_role.arn
  subnet_ids      = var.private_subnet_ids
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
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_registry
  ]
}

#----------------IAM Role for Pod Identity----------------
resource "aws_eks_addon" "pod_identity" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"
}
data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}
#----------------IAM Role for Pod Identity----------------
resource "aws_iam_role" "pod_identity_role" {
  name               = "${var.cluster_name}-POD-IDENTITY-ROLE"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}
#----------------IAM Policy for Pod Identity----------------
resource "aws_iam_policy" "pod_identity_policy" {
  name        = "${var.cluster_name}-POD-IDENTITY-POLICY"
  path        = "/"
  description = "IAM policy for AWS Load Balancer Controller parsed from local file"
  policy      = file("${path.module}/iam_policy.json")
}
#----------------IAM Role Attachment----------------
resource "aws_iam_role_policy_attachment" "pod_identity_policy" {
  policy_arn = aws_iam_policy.pod_identity_policy.arn
  role       = aws_iam_role.pod_identity_role.name
}
#----------------EKS Pod Identity Association----------------
resource "aws_eks_pod_identity_association" "pod_identity" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = var.alb_namespace
  service_account = var.alb_service_account_name
  role_arn        = aws_iam_role.pod_identity_role.arn
  depends_on = [
    aws_eks_addon.pod_identity,
    aws_iam_role_policy_attachment.pod_identity_policy
  ]
}
