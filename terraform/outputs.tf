# Outputs for Web Hosting Infrastructure

output "vpc_id" {
  description = "The ID of the VPC created for the infrastructure."
  value       = module.networking.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = module.networking.private_subnets
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.compute.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = module.compute.eks_cluster_endpoint
}

output "eks_cluster_kubeconfig" {
  description = "The kubeconfig for the EKS cluster."
  value       = module.compute.eks_kubeconfig
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = module.database.dynamodb_table_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database."
  value       = module.database.rds_endpoint
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket."
  value       = module.storage.s3_bucket_name
}

output "elasticache_cluster_endpoint" {
  description = "The endpoint of the ElastiCache cluster."
  value       = module.storage.elasticache_cluster_endpoint
}

output "ci_cd_pipeline_name" {
  description = "The name of the CI/CD pipeline."
  value       = module.cicd.pipeline_name
}

output "prometheus_dashboard_url" {
  description = "URL of the Prometheus dashboard."
  value       = module.monitoring.prometheus_dashboard_url
}

output "grafana_dashboard_url" {
  description = "URL of the Grafana dashboard."
  value       = module.monitoring.grafana_dashboard_url
}
