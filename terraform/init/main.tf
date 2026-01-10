locals {
  bucket_name = "home-assig-remote-state"
  environment = "dev"
}


resource "aws_s3_bucket" "tf_state" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = local.environment
    ManagedBy   = "terraform"
    Purpose     = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

