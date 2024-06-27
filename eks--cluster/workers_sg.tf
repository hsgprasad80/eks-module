resource "aws_security_group" "workers" {
  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  revoke_rules_on_delete = true

  name        = "${module.eks_cluster.eks_cluster_id}-workers"
  description = "Security group for eks worker nodes"
}

resource "aws_security_group_rule" "ingress_workers" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks       = data.terraform_remote_state.network.outputs.private_subnets_cidr_blocks
  security_group_id = aws_security_group.workers.id
}
resource "aws_security_group_rule" "workers_selfingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.workers.id
  security_group_id        = aws_security_group.workers.id
}
resource "aws_security_group_rule" "workers_http_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker_http.id
  security_group_id        = aws_security_group.workers.id
}
resource "aws_security_group_rule" "workers_cluster_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = module.eks_cluster.eks_cluster_managed_security_group_id
  security_group_id        = aws_security_group.workers.id
}


resource "aws_security_group_rule" "workers_egress_world" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.workers.id
}