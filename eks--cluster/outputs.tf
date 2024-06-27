output "security_group_id" {
  description = "ID of the created Security Group for the EKS cluster"
  value       = module.eks_cluster.eks_cluster_managed_security_group_id
}

output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks_cluster.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks_cluster.eks_cluster_version
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer
}

output "eks_cluster_identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn
}

output "eks_cluster_certificate_authority_data" {
  description = "The Kubernetes cluster certificate authority data"
  value       = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "eks_cluster_managed_security_group_id" {
  description = "Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads"
  value       = module.eks_cluster.eks_cluster_managed_security_group_id
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = module.eks_cluster.eks_cluster_role_arn
}

# output "kubernetes_config_map_id" {
#   description = "ID of `aws-auth` Kubernetes ConfigMap"
#   value       = module.eks_cluster.kubernetes_config_map_id
# }

output "cluster_encryption_config_enabled" {
  description = "If true, Cluster Encryption Configuration is enabled"
  value       = module.eks_cluster.cluster_encryption_config_enabled
}

output "cluster_encryption_config_resources" {
  description = "Cluster Encryption Config Resources"
  value       = module.eks_cluster.cluster_encryption_config_resources
}

output "cluster_encryption_config_provider_key_arn" {
  description = "Cluster Encryption Config KMS Key ARN"
  value       = module.eks_cluster.cluster_encryption_config_provider_key_arn
}

output "cluster_encryption_config_provider_key_alias" {
  description = "Cluster Encryption Config KMS Key Alias ARN"
  value       = module.eks_cluster.cluster_encryption_config_provider_key_alias
}

output "cloudwatch_log_group_name" {
  description = "The name of the log group created in cloudwatch where cluster logs are forwarded to if enabled"
  value       = module.eks_cluster.cloudwatch_log_group_name
}

output "cloudwatch_log_group_kms_key_id" {
  description = "KMS Key ID to encrypt AWS CloudWatch logs"
  value       = module.eks_cluster.cloudwatch_log_group_kms_key_id
}

output "linux_node_role_arn" {
  description = "IAM Role for Linux Nodes"
  value       = aws_iam_role.worker_role.arn
}

output "velero_backup_s3_bucket" {
  value = aws_s3_bucket.eks_cluster.arn
}