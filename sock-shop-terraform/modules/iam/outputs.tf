output "eks_cluster_admin_role_arn" {
  value = aws_iam_role.eks_cluster_admin.arn
}