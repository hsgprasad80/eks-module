data "terraform_remote_state" "network" {   
  backend = "s3"
   
  config = {
    bucket = "guru-prod-terraform-state"

    key     = "env:/${terraform.workspace}/vpc-module/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = "true"
  }
}

locals {
  private_subnet_ids = [
    data.terraform_remote_state.network.outputs.private_subnets[0],
    data.terraform_remote_state.network.outputs.private_subnets[1],
    data.terraform_remote_state.network.outputs.private_subnets[2]
  ]
}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
    arn = data.aws_caller_identity.current.arn
}