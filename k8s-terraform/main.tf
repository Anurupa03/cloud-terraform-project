terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "namespace" {
  source = "./modules/namespace"

  name        = var.namespace
  environment = var.environment
}

module "app" {
  source = "./modules/app"

  namespace   = module.namespace.name
  environment = var.environment
  replicas    = var.replicas
}