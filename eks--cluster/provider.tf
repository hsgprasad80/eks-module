# Provider
provider "aws" {
  default_tags {
      tags = {
          createdby = "terraform"
      }
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }  
  }

  backend "s3" {}
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks_cluster.eks_cluster_id
}

provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = module.eks_cluster.eks_cluster_certificate_authority_data
  token                  = data.aws_eks_cluster_auth.default.token
}