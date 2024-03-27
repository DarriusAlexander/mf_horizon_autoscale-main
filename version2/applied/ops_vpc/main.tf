#-----------------------
# DevOps - VPC
#-----------------------

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
    bucket = "mf-s3-tf-statefiles"
    key    = "version2/vpc_ops/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "mf-tf-locks"
    encrypt        = true
  }
}

module "module_pemfile" {
  source = "../../modules/keypair/"

  key_name = var.key_name
  filename = var.filename
}

module "module_vpc" {
  source = "../../modules/vpc/"

  environment            = var.environment
  created_by             = var.created_by
  vpc_name               = var.vpc_name
  vpc_cidr_block         = var.vpc_cidr_block
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  azs                    = var.azs
  destination_cidr_block = var.destination_cidr_block
}


