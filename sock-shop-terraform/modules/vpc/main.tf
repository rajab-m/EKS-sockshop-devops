module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = var.name
  cidr = var.cidr
  azs  = ["${var.region}a", "${var.region}b"]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24", # EKS AZ1
    "10.0.12.0/24", # EKS AZ2
    "10.0.21.0/24", # DB AZ1
    "10.0.22.0/24"  # DB AZ2
  ]

  enable_nat_gateway      = true
  one_nat_gateway_per_az  = true
  enable_dns_support      = true
  enable_dns_hostnames    = true

  # Tags for EKS
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  # Public Subnet tags for ELB 
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  # Private Subnet tags for Internal ELB 
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
