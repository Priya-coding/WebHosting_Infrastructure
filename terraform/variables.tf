# Variables Configuration for Web Hosting Infrastructure

variable "primary_region" {
  description = "Primary AWS region for resource deployment"
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for disaster recovery"
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets and other resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "webhosting-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  default     = "1.24"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  default     = "webhosting-dynamodb-table"
}

variable "db_name" {
  description = "Name of the RDS database"
  default     = "webhosting-db"
}

variable "db_engine" {
  description = "Engine for the RDS database "
  default     = "postgres"
}

variable "s3_bucket" {
  description = "Name of the S3 bucket"
  default     = "webhosting-s3-bucket"
}

variable "cache_cluster_name" {
  description = "Name of the ElastiCache cluster"
  default     = "webhosting-elasticache-cluster"
}

variable "repo_name" {
  description = "Name of the CodeCommit or GitHub repository"
  default     = "webhosting-repo"
}

variable "buildspec_file" {
  description = "Path to the buildspec file for CodeBuild"
  default     = "buildspec.yml"
}

variable "prometheus_config" {
  description = "Configuration file path for Prometheus"
  default     = "../configs/prometheus-config.yaml"
}

variable "grafana_admin_user" {
  description = "Admin username for Grafana"
  default     = "admin"
}

variable "grafana_admin_pass" {
  description = "Admin password for Grafana"
  default     = "admin123"
}

variable "kubeconfig" {
  description = "Path to Kubernetes kubeconfig file"
  default     = "~/.kube/config"
}

variable "ec2_instance_config" {
  description = "Configuration for EC2 instances, including type and AMI"
  type = list(object({
    ami            = string
    instance_type  = string
  }))
  default = [
    {
      ami           = "ami-12345678" 
      instance_type = "t3.medium"
    }
  ]
}
