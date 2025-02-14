# Providers Configuration for Web Hosting Infrastructure

# Default provider for the primary region
provider "aws" {
  region = var.primary_region
}

# Aliased provider for the secondary region
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

variable "primary_region" {
  description = "Primary AWS region for resource deployment"
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for disaster recovery"
  default     = "us-west-2"
}

variable "kubeconfig" {
  description = "Path to Kubernetes kubeconfig file"
  default     = "~/.kube/config"
}
