####################################################
# Main Terraform file for Web Hosting Infrastructure
####################################################


# Local variables for common tags
locals {
  common_tags = {
    Project     = "WebHosting"
    Environment = var.environment
  }
}

####################################################
# Networking Module: Provisions VPC, subnets,
# and security groups
####################################################

module "vpc" {
  source   = "../modules/networking/vpc"
  vpc_cidr = var.vpc_cidr
  tags     = local.common_tags
}

module "subnets" {
  source         = "../modules/networking/subnets"
  vpc_id         = module.vpc.vpc_id
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  tags           = local.common_tags
}

module "security_groups" {
  source = "../modules/networking/security_groups"
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags
}


####################################################
# Compute Module: Provisions EKS cluster, 
# Lambda functions, and Spot EC2 instances
####################################################

module "eks_cluster" {
  source         = "../modules/compute/eks"
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  subnets        = module.subnets.private_subnets
  tags           = local.common_tags
}

module "lambda_functions" {
  source = "../modules/compute/lambda"
  vpc_id = module.vpc.vpc_id
  subnets = module.subnets.private_subnets
  tags    = local.common_tags
}

module "ec2_instances" {
  source      = "../modules/compute/ec2"
  vpc_id      = module.vpc.vpc_id
  subnets     = module.subnets.private_subnets
  instance_config = var.ec2_instance_config
  tags        = local.common_tags
}


####################################################
####################################################

####################################################
####################################################

####################################################
####################################################

####################################################
####################################################