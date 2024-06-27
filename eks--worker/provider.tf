terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "guru-prod-terraform-state"
    key    = "eks--workers-system/terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      team = "infrastructure",
      app  = "shared",
      env  = var.stage
    }
  }
}
