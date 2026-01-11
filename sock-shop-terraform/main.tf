terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }

  }

  required_version = ">= 1.5.0"
}

# Use the aws_secretsmanager_secret_version data source:
# RDS credentials
data "aws_secretsmanager_secret_version" "rds" {
  secret_id = "rds-credentials"
}

# DocumentDB credentials
data "aws_secretsmanager_secret_version" "docdb" {
  secret_id = "docdb-credentials"
}

# jsondecode() converts the JSON string into a map we can use
locals {
  rds_creds = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
  docdb_creds = jsondecode(data.aws_secretsmanager_secret_version.docdb.secret_string)
}


module "vpc" {
  source = "./modules/vpc"

  name   = var.project_name
  region = var.region
  cidr = var.cidr 
  cluster_name = var.project_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.eks_private_subnets
  bastion_sg   = module.bastion.bastion_sg
  key_name   = var.key_name   # to get ssh access by the bastion
  depends_on = [module.vpc]
}

module "bastion" {
  source = "./modules/bastion"

  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.public_subnets[0]
  key_name   = var.key_name
  allowed_ip = var.allowed_ip
}

# ----------------------------
# RDS MySQL Catalogue DB
# ----------------------------
module "rds" {
  source = "./modules/database/RDS"

  db_subnet_ids = module.vpc.db_private_subnets
  db_username   = local.rds_creds.username
  db_password   = local.rds_creds.password
  vpc_id       = module.vpc.vpc_id
  security_groups = [module.eks.eks_sg,  module.bastion.bastion_sg]
}

# ----------------------------
# DocumentDB Cluster (carts, users, orders)
# ----------------------------
module "docdb" {
  source = "./modules/database/DokumentDB"

  db_subnet_ids = module.vpc.db_private_subnets
  docdb_user   = local.docdb_creds.username
  docdb_pass   = local.docdb_creds.password
  vpc_id       = module.vpc.vpc_id
  security_groups = [module.eks.eks_sg, module.bastion.bastion_sg]
}
# ----------------------------
# IAM roles for eks (users)  
# ----------------------------
module "iam" {
  source = "./modules/iam"
  cluster_name = var.project_name
  depends_on = [module.eks]
}








