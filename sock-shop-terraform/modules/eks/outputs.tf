output "cluster_name" {
  value = module.eks.cluster_name
}
output "eks_sg" {
  description = "Security group ID of the EKS managed node group 'general'"
  value       = module.eks.node_security_group_id
  
}

output "cluster_endpoint" {
  description = "The EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded CA certificate for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
  
}



