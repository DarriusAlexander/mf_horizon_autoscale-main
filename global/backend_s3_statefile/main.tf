# This is the gloval s3_bucket for Mariner Finance
# All `state files` should live here with respect to their environment.
# The naming convention should be reflected in the file path
# A "free" tier DynamoDB database will be used for the .lockfile
# Once s3_bucket & DynamoDB table has been created, you'll need to push the state file to the 
# s3_bucket. 
# Remember that the s3_bucket must exist 1st before using the `backend` remote state

provider "aws" {
  region     = var.global_default_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "mf-s3-tf-statefiles"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_default" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table
# table that has a primary key called LockID (with this exact spelling and capitalization)
resource "aws_dynamodb_table" "tf_locks" {
  name         = "mf-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Push statefile to s3_bucket
terraform {
  backend "s3" {
    # bucket name must be declared
    bucket = "mf-s3-tf-statefiles"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "mf-tf-locks"
    encrypt        = true
  }
}
