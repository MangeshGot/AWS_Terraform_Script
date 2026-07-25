#--------------------S3 Bucket for Terraform State File--------------------
resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_name
  force_destroy = false
}
#--------------------S3 Bucket Versioning for Terraform State File--------------------
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
#--------------------S3 Bucket Server Side Encryption Configuration for Terraform State File--------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"

    }
  }
}
