data "aws_caller_identity" "current" {
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "guru-${var.stage}-terraform-state"
    key     = "env:/${terraform.workspace}/vpc-module/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

data "terraform_remote_state" "eks_cluster" {
  backend = "s3"

  config = {
    bucket  = "guru-${var.stage}-terraform-state"
    key     = "env:/${terraform.workspace}/eks-module/eks--cluster/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

locals {
  worker_subnet_ids = slice(data.terraform_remote_state.network.outputs.private_subnets, 1, 2)
}