variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr value"
  default     = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = "Ops"
}

variable "vpc_name" {
  type        = string
  default     = "ops_vpc"
  description = "aws virtual private cloud"
}

variable "azs" {
  type        = list(string)
  description = "aws availability zones"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "public subnet cidr values"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "public subnet cidr values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "created_by" {
  type        = string
  default     = "dev_ops"
  description = "created by"
}

variable "destination_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "key_name" {
  type    = string
  default = "ops-key-openssh"
}

variable "filename" {
  type    = string
  default = "ops-key"
}

variable "sg_egress" {
  type = map(object({
    cidr_ipv4   = string,
    ip_protocol = string
    tags        = map(string)
  }))
  default = {
    base_egress = {
      cidr_ipv4 = "0.0.0.0/32"

      tags = {
        Name = "sandbox_one"
      }
    },
    sandbox_two = {
      instance_type = "t2.micro"
      tags = {
        Name = "sandbox_two"
      }
    },
    sandbox_three = {
      instance_type = "t2.nano"
      tags = {
        Name = "sandbox_three"
      }
    }
  }
}
