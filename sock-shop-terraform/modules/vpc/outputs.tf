output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}


output "eks_private_subnets" {
  value = slice(module.vpc.private_subnets, 0, 2)
}

output "db_private_subnets" {
  value = slice(module.vpc.private_subnets, 2, 4)
}
