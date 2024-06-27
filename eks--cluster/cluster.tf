locals {
  cluster_subnet_ids   = slice(data.terraform_remote_state.network.outputs.private_subnets, 0, 2)
  worker_subnet_ids    = slice(data.terraform_remote_state.network.outputs.private_subnets, 1, 2)
  worker_subnet_v2_ids = slice(data.terraform_remote_state.network.outputs.private_subnets, 1, 2)

   access_entry_map = {
    # Note that we no longer remove the path!
    (data.aws_iam_session_context.current.issuer_arn) = {
      kubernetes_groups = ["devops"]
      access_policy_associations = {
        ClusterAdmin = {}
      }
    }
    ##### No need to add the access entry for managed nodes as EKS will add it automatically. ######
    "arn of your linux instance role" = {
      type = "EC2_LINUX"
      # kubernetes_groups = ["system:nodes"]
      ####### No need to configure user names EKS will add it for us ################
      # user_name         = "system:node:{{EC2PrivateDNSName}}"

    }
    "arn of your windows instance role" = {
      type = "EC2_WINDOWS"
      # kubernetes_groups = ["system:nodes", "eks:kube-proxy-windows"]
      ####### No need to configure user names EKS will add it for us ################
      # user_name         = "system:node:{{EC2PrivateDNSName}}"
    }
  }
}

module "eks_cluster" {
  source     = "cloudposse/eks-cluster/aws"
  version    = "4.0.0"
  stage      = "dev"
  name       = var.name
  attributes = var.attributes
  tags       = var.tags
  
  region = var.aws_region

  kubernetes_version = var.kubernetes_version

  #vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = local.cluster_subnet_ids

  enabled_cluster_log_types = ["authenticator", "audit"]
  oidc_provider_enabled     = true

  #cluster_encryption_config_kms_key_id = var.kms_arn
  cluster_encryption_config_enabled = true
  cluster_log_retention_period      = 30

  allowed_security_group_ids = [aws_security_group.workers.id]
  # this is required for accessing cluster from twingate (nat ip's needs whitelisting)
  # public_access_cidrs = var.public_access_cidrs 

  endpoint_private_access = true
  endpoint_public_access  = true

  access_entry_map = local.access_entry_map
  access_config = {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }
   
  #kubernetes_network_ipv6_enabled = true

  ### We have to manually add our SSO users to the auth map so its simpler to just update it manually

  # Addons are managed with eksctl; its just less mess.
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = module.eks_cluster.eks_cluster_id
}

resource "aws_security_group_rule" "workers" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks       = data.terraform_remote_state.network.outputs.private_subnets_cidr_blocks
  security_group_id = module.eks_cluster.eks_cluster_managed_security_group_id
}
