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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

##
variable "kubernetes_version" {
  default = "1.27"
}
#
variable "instance_types" {
  type        = list(string)
  description = "Instance types to launch"
}

variable "max_size" {
  default     = 6
  description = "The maximum size of the AutoScaling Group"
}

variable "min_size" {
  default     = 3
  description = "The minimum size of the AutoScaling Group"
}

variable "desired_size" {
  default     = 3
  description = "Desired size of the ASG"
}

variable "autoscaling_policies_enabled" {
  type        = bool
  default     = true
  description = "Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling"
}
###
variable "security_group_id" {
  type        = string
  description = "worker security group"
}
