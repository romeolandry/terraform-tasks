terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31.0"
    }
  }

}

provider "aws" {
  region = "eu-central-1"
}

// S3 bucket
# 1. The S3 Bucket
resource "aws_s3_bucket" "my_backend_state_bucket" {
  bucket = "kcrl-two-test-my-unique-terraform-state-2026"

  lifecycle {
    prevent_destroy = true
  }
}

# 2. Enable Versioning (Crucial for State)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.my_backend_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.my_backend_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// Locking - Dynamo DB

resource "aws_dynamodb_table" "my_backend_state_bucket_table_lock" {
  name         = "my_backend_state_bucket_table_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
