# elb is requried when you want to load balance the traffic to EKS from nginx

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.${var.workerlbsubdomain}.${var.zone_name}"
#   validation_method = "DNS"

#   tags = {
#     Environment = "${var.stage}"
#     "owners"    = "ops"
#     "workspace" = terraform.workspace
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "cert" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = var.zone_id
# }

# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
# }

resource "aws_elb" "k8_elb" {
  name = "ilb-${module.eks_cluster.eks_cluster_id}"

  subnets = local.private_subnet_ids
  security_groups = [aws_security_group.worker_http.id]

  # security_groups = concat(
  #   [data.terraform_remote_state.network.outputs.ops_sg],
  #   [aws_security_group.worker_http.id],
  # )

  internal                  = true
  cross_zone_load_balancing = true
  connection_draining       = true

  listener {
    instance_port     = "80"
    instance_protocol = "tcp"
    lb_port           = "80"
    lb_protocol       = "tcp"
  }
  # listener {
  #   instance_port      = "443"
  #   instance_protocol  = "ssl"
  #   lb_port            = "443"
  #   lb_protocol        = "ssl"
  #   ssl_certificate_id = aws_acm_certificate_validation.cert.certificate_arn
  # }

  health_check {
    target              = "TCP:80"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 7
  }

  tags = {
    "owners"    = "ops"
    "workspace" = terraform.workspace
  }
}

output "workerlb_arn" {
  value = element(concat(aws_elb.k8_elb.*.arn, [""]), 0)
}

# output "workerlb_dns_name" {
#   value = element(concat(aws_elb.k8_elb.*.dns_name, [""]), 0)
# }

output "workerlb_id" {
  value = element(concat(aws_elb.k8_elb.*.id, [""]), 0)
}

# variable "zone_id" {
#   description = "Pulls from Dockerfile Variables"
# }

# resource "aws_route53_record" "worker_elb" {
#   zone_id = var.zone_id
#   name    = "${var.workerlbprefix}-${terraform.workspace}.${var.workerlbsubdomain}."
#   type    = "CNAME"
#   ttl     = "90"
#   records = [element(concat(aws_elb.k8_elb.*.dns_name, [""]), 0)]
# }

#*.uk-dev.dev.ivsrv.uk