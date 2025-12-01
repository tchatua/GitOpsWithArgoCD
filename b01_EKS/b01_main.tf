##############################################
# VPC Module
##############################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.cluster_name
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment # added
  }
}

##############################################
# EKS Module
##############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
    }
  }

  # Enables public API endpoint (so I can run kubectl locally)
  cluster_endpoint_public_access = true
  # Keeps private endpoint active (recommended)
  cluster_endpoint_private_access = true # optional: keep both enabled
#   manage_aws_auth = true  # <--- this ensures your IAM user is added


  tags = {
    # Environment = "test"
    Environment = var.environment
  }
}