# Cluster-level admin 
data "aws_caller_identity" "current" {}

# Flexible cluster-level admin role
resource "aws_iam_role" "eks_cluster_admin" {
  name = "eks-cluster-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        # Anyone who has permission in IAM can assume this role
        Principal = {
          AWS = data.aws_caller_identity.current.arn   # for now only me can have the permissions, here we can add users in the future
        }
      }
    ]
  })

  tags = {
    Name = "eks-cluster-admin"
  }
}


# Attach EKS policies to the cluster-level role
# Cluster management
resource "aws_iam_role_policy_attachment" "eks_admin_policy" {
  role       = aws_iam_role.eks_cluster_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Service access (needed for kubectl)
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Kubernetes access (EKS RBAC) 4a. Authentication
resource "aws_eks_access_entry" "cluster_admin_entry" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.eks_cluster_admin.arn
  type          = "STANDARD"
}

# Kubernetes access (EKS RBAC) 4b. Authorization
resource "aws_eks_access_policy_association" "cluster_admin_policy" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.eks_cluster_admin.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

