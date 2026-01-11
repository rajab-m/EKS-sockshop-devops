
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"
  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true  # add the cluster creator (the identity used by Terraform) as an administrator via access entry
  compute_config = {
    enabled    = false
  }
  # eks_managed_node_groups
  eks_managed_node_groups = {
    general = {
      name = "general"
      ami_type       = "AL2023_x86_64_STANDARD"
      min_size     = 3
      max_size     = 6
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      key_name        = var.key_name
      
      tags = {
        Name = "eks-node"
      }
      enable_monitoring = true
    }
  }

# allow all traffic from bastion to worker nodes (NOT control plane)
node_security_group_additional_rules = {
  allow_all_from_bastion = {
    type                         = "ingress"
    protocol                     = "-1"     # all protocols
    from_port                    = 0
    to_port                      = 0
    description                  = "Allow all traffic from Bastion to nodes"
    source_security_group_id     = var.bastion_sg
    source_cluster_security_group = false
  }
  # Allow full node-to-node communication
  allow_node_to_node = {
    type                          = "ingress"
    protocol                      = "-1"     # all protocols
    from_port                     = 0
    to_port                       = 0
    description                   = "Allow all traffic between worker nodes"
    source_cluster_security_group = true
  }
}

  
  
  tags = {
      Environment = "dev"
      Terraform   = "true"
    }  
}

