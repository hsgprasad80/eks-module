module "worker_label" {
  source = "cloudposse/label/null"

  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

data "aws_iam_role" "worker_role" {
  name = "${data.terraform_remote_state.eks_cluster.outputs.eks_cluster_id}_workerinstance_role"
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "2.12.0"

  enabled = true

  context = module.worker_label.context

  instance_types     = var.instance_types
  subnet_ids         = local.worker_subnet_ids
  min_size           = var.min_size
  max_size           = var.max_size
  desired_size       = var.desired_size
  cluster_name       = data.terraform_remote_state.eks_cluster.outputs.eks_cluster_id
  kubernetes_version = var.kubernetes_version == null || var.kubernetes_version == "" ? [data.terraform_remote_state.eks_cluster.outputs.eks_cluster_version] : [var.kubernetes_version]
  kubernetes_labels  = var.labels

  ami_type = "BOTTLEROCKET_x86_64"

  update_config = [{ max_unavailable = var.desired_size }]

  capacity_type               = "SPOT"
  detailed_monitoring_enabled = true

  # kubernetes_taints = [{
  #   key    = "role"
  #   value  = "system"
  #   effect = "NO_SCHEDULE"
  # }]

  node_role_arn                = [data.aws_iam_role.worker_role.arn]
  node_role_cni_policy_enabled = false #We use the Service Account as per best practice

  associated_security_group_ids = [
  # data.terraform_remote_state.network.outputs.rancher_sg,
  # data.terraform_remote_state.network.outputs.ops_ssh,
  data.terraform_remote_state.eks_cluster.output.security_group_id
  # var.security_group_id
  ]

  # Enable the Kubernetes cluster auto-scaler to find the auto-scaling group
  cluster_autoscaler_enabled = var.autoscaling_policies_enabled

  create_before_destroy = true

  node_role_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  block_device_map = {
    "/dev/xvda" = {
      "ebs" : {
        "delete_on_termination" : true,
        "encrypted" : true,
        "volume_size" : 30,
        "volume_type" : "gp3"
      }
    },
    "/dev/xvdb" = {
      "ebs" : {
        "delete_on_termination" : true,
        "encrypted" : true,
        "volume_size" : 60,
        "volume_type" : "gp3"
      }
    }
  }

  node_group_terraform_timeouts = [{
    create = "15m"
    update = "30m"
    delete = "20m"
  }]
  #Valid types are "instance", "volume", "elastic-gpu", "spot-instances-request", "network-interface".
  resources_to_tag = ["instance", "volume", "spot-instances-request", "network-interface"]
}

resource "aws_autoscaling_attachment" "eks_web_node_group_autoscaling_attachment" {
  autoscaling_group_name = element(element(module.eks_node_group.eks_node_group_resources, 1), 1).autoscaling_groups[0].name
  elb                    = data.terraform_remote_state.eks_cluster.outputs.workerlb_id
}