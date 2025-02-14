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
# CI/CD Module: Automates the deployment pipeline
# with CodeBuild and ECR
####################################################
module "codebuild" {
  source         = "../modules/cicd/codebuild"
  repo_name      = var.repo_name
  buildspec_file = var.buildspec_file
  tags           = local.common_tags
}

module "ecr" {
  source = "../modules/cicd/ecr"
  repo_name = var.repo_name
  tags      = local.common_tags
}

module "argocd" {
  source = "../modules/cicd/argocd"
  eks_cluster_name = module.eks_cluster.cluster_name
  repo_url         = var.repo_url
  tags             = local.common_tags
}


####################################################
# Database Module: Sets up DynamoDB configurations
####################################################
module "dynamodb" {
  source    = "../modules/database/dynamodb"
  table_name = var.dynamodb_table_name
  tags      = local.common_tags
}

####################################################
# Monitoring Module: Configures monitoring tools
# like CloudWatch, Prometheus, and Grafana
####################################################
module "cloudwatch" {
  source = "../modules/monitoring/cloudwatch"
  alarms = var.cloudwatch_alarms
  tags   = local.common_tags
}

module "prometheus" {
  source      = "../modules/monitoring/prometheus"
  config_file = var.prometheus_config
  tags        = local.common_tags
}

module "grafana" {
  source       = "../modules/monitoring/grafana"
  admin_user   = var.grafana_admin_user
  admin_pass   = var.grafana_admin_pass
  tags         = local.common_tags
}

####################################################
# Storage Module: Configures S3 buckets
# and ElastiCache for caching
####################################################
module "s3" {
  source    = "../modules/storage/s3"
  bucket_name = var.s3_bucket
  tags      = local.common_tags
}

module "elasticache" {
  source       = "../modules/storage/elasticache"
  cluster_name = var.cache_cluster_name
  subnets      = module.subnets.private_subnets
  vpc_id       = module.vpc.vpc_id
  tags         = local.common_tags
}

####################################################
# Helm Module: Deploys Helm charts to the EKS cluster
####################################################
module "helm_nginx" {
  source           = "../modules/helm"
  name             = "nginx-ingress"
  namespace        = "kube-system"
  chart            = "ingress-nginx/ingress-nginx"
  version          = "4.0.6"
  values           = ["../configs/nginx-ingress-values.yaml"]
  eks_cluster_name = module.eks_cluster.cluster_name
  kubeconfig       = module.eks_cluster.kubeconfig
  tags             = local.common_tags
}

module "helm_prometheus" {
  source           = "../modules/helm"
  name             = "prometheus"
  namespace        = "monitoring"
  chart            = "prometheus-community/prometheus"
  version          = "14.0.0"
  values           = ["../configs/prometheus-values.yaml"]
  eks_cluster_name = module.eks_cluster.cluster_name
  kubeconfig       = module.eks_cluster.kubeconfig
  tags             = local.common_tags
}

module "helm_grafana" {
  source           = "../modules/helm"
  name             = "grafana"
  namespace        = "monitoring"
  chart            = "grafana/grafana"
  version          = "6.17.4"
  values           = ["../configs/grafana-values.yaml"]
  eks_cluster_name = module.eks_cluster.cluster_name
  kubeconfig       = module.eks_cluster.kubeconfig
  tags             = local.common_tags
}

####################################################
# NGINX Module: Deploys standalone NGINX for 
# additional configurations
####################################################


# Outputs
output "vpc_id" {
  description = "The ID of the VPC created for the infrastructure."
  value       = module.networking.vpc_id
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.compute.cluster_name
}

output "database_name" {
  description = "The name of the database configured."
  value       = module.database.db_name
}

output "ci_cd_pipeline_name" {
  description = "The name of the CI/CD pipeline."
  value       = module.cicd.pipeline_name
}

output "monitoring_dashboard_url" {
  description = "URL of the Grafana monitoring dashboard."
  value       = module.monitoring.grafana_dashboard_url
}