
## Generic
variable "aws_region" {
  type = string
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev' or 'testing'"
}

variable "name" {
  type        = string
  default     = "eks"
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "aws_assume_role_arn" {
  type    = string
  default = ""
}


// ELB
# variable "zone_name" {
#   type        = string
#   description = ""
# }
variable "workerlbprefix" {
  type        = string
  description = "prefix like worker"
}
variable "workerlbsubdomain" {
  type        = string
  description = "subdomain used for acm like de-prod"
}

# variable "rancher_ingress_cidr" {
#   description = "This is usually the NAT address range for the rancher server"
# }

# Cluster

variable "kubernetes_version" {
  type = string
}

variable "kms_arn" {
  type    = string
  default = ""
}

variable "cluster_tags" {
  type    = map(string)
  default = {}
}
variable "public_access_cidrs" {
  type    = list(string)
  default = []
}


# Web Workers
variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Instance type to launch"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}


variable "instance_types" {
  type    = list(string)
  default = []
}
variable "desired_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "tags" {
  type    = map(string)
  default = {}
}

