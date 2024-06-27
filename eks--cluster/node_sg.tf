resource "aws_security_group" "worker_http" {
  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  revoke_rules_on_delete = true

  name        = "${module.eks_cluster.eks_cluster_id}-worker-http"
  description = "Allow standard web traffic"

  tags = merge(var.tags, {
    "karpenter.sh/discovery" = module.eks_cluster.eks_cluster_id
  })
}

resource "aws_security_group_rule" "ingress" {
  description = "Allow all HTTPs inbound"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks       = data.terraform_remote_state.network.outputs.private_subnets_cidr_blocks
  security_group_id = aws_security_group.worker_http.id
}

resource "aws_security_group_rule" "httpingress" {
  description = "Allow all HTTP inbound"
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  
  cidr_blocks       = data.terraform_remote_state.network.outputs.private_subnets_cidr_blocks
  security_group_id = aws_security_group.worker_http.id
}

resource "aws_security_group_rule" "egress_world80" {
  description       = "Allow all HTTP outbound"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_http.id
}

resource "aws_security_group_rule" "egress_world443" {
  description       = "Allow all HTTPs outbound"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_http.id
}

resource "aws_security_group_rule" "egress_world" {
  description       = "Allow all egress"
  type              = "egress"
  from_port         = 32768
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_http.id
}