output "public_ip" {
  value = aws_instance.bastion.public_ip
}
output "bastion_sg" {
  description = "Security group ID of the EKS managed node group 'general'"
  value       = aws_security_group.bastion.id
  
}
