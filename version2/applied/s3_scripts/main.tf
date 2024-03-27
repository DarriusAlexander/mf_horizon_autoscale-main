#---------------------------------------
# DevOps - s3
# Path: version2/applied/s3_scipt
# Date: 01/11/24
#---------------------------------------

terraform {
  # required_version = "~> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "mariner"
  region                   = var.aws_region
}

# Push statefile to s3_bucket
terraform {
  backend "s3" {
    # bucket name must be declared
    bucket         = "mf-s3-tf-statefiles"
    key            = "version2/s3_scripts/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mf-tf-locks"
    encrypt        = true
  }
}


module "module_s3_bucket" {
  source = "../../modules/s3/basic"

  environment             = var.environment
  created_by              = var.created_by
  bucket_name             = var.bucket_name
  ignore_public_acls      = var.ignore_public_acls
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  acl                     = var.acl
  prevent_destroy         = var.prevent_destroy
  force_destroy           = var.force_destroy
  status                  = var.status
  fileset                 = var.fileset
}


# Bucket Policy 
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.module_s3_bucket.s3_bucket_id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Access-to-bucket-in-specific-account-only",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "*",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
         ],
         "Condition": {
           "StringEquals": {
             "aws:sourceVpce": "${var.vpce_id}"
           }
         }
       },
       {
         "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1701994075017",
         "Effect": "Allow",
         "Principal": {
           "Service": "logging.s3.amazonaws.com"
         },
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
      ]
    }
    EOF
}
