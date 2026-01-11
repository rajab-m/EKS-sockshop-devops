output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

output "eks_cluster_admin_role_arn" { value = module.iam.eks_cluster_admin_role_arn }

output "eks_cluster_admin_message" {
  value = <<EOT
Use this command to configure kubectl for your EKS cluster:

aws eks update-kubeconfig \
    --name ${module.eks.cluster_name} \
    --region eu-west-3 \
    --role-arn ${module.iam.eks_cluster_admin_role_arn}
EOT
}



