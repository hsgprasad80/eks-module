resource "aws_s3_bucket" "eks_cluster" {
  bucket = "${var.namespace}-${module.eks_cluster.eks_cluster_id}"

  tags = {
    Name        = "${module.eks_cluster.eks_cluster_id}-velero-backup"
    Environment = var.stage
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.eks_cluster.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.eks_cluster.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}