# Environment : DEV
variable "environment" {
  type    = string
  default = "DEV"
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

# VPC_Peering : [Development, STAGING]
# define the VPC 
variable "vpc_id" {
  type        = string
  default     = "vpc-c02444a6"
  description = "marinerfinance.vpc.dev"
}

variable "public_az1_subnet_id" {
  type        = string
  default     = "subnet-2417156d"
  description = "marinerfinance.vpc.public_az1_subnet_id"
}

variable "public_az2_subnet_id" {
  type        = string
  default     = "subnet-20743c7b"
  description = "marinerfinance.vpc.public_az2_subnet_id"
}

variable "hostname" {
  type        = string
  default     = "marinerfinance.io"
  description = "host name : marinerfinance.io"
}

variable "host_zone_id" {
  type        = string
  default     = "Z2IBKYHNH8JNU"
  description = "marinerfinance.io route53 host"
}

variable "existing_role" {
  type        = string
  default     = "ec2_access_ops_s3_scripts"
  description = "predifined role"
}

# Environment: DEVE
# SecurityGroup: MSG_DEV
variable "security_group_id" {
  type        = string
  default     = "sg-04c8288c28d02b79a"
  description = "marinerfinance.securitygroup.dev"
}

#SSL Certificate
variable "ssl_cert" {
  type        = string
  default     = "arn:aws:acm:us-east-1:625524351863:certificate/fd76ae1b-b53f-4aa4-b33c-e00e65d35a48"
  description = "marinerfinance.ssl.certificate"
}

# Set Route53 FQDNs
variable "domains" {
  type = set(string)
  default = [
    "cac-integration-dev.marinerfinance.io",
    "msa-integration-dev.marinerfinance.io",
    "psa-integration-dev.marinerfinance.io",
    "dsa-integration-dev.marinerfinance.io",
    "esa-integration-dev.marinerfinance.io",
    "jsa-integration-dev.marinerfinance.io",
    "dcp-integration-dev.marinerfinance.io"
  ]
}
variable "domains_internal" {
  type = set(string)
  default = [
    "psa-integration-dev-internal.marinerfinance.io",
    "dsa-integration-dev-internal.marinerfinance.io",
    "esa-integration-dev-internal.marinerfinance.io",
    "jsa-integration-dev-internal.marinerfinance.io",
    "dcp-integration-dev-internal.marinerfinance.io"
  ]
}
# variable "domain_names" {
#   type = map(object({
#     name = string
#   }))
#   default = {
#     dns_one = {
#       name = "cac.integration.dev.marinerfinance.io"
#     }
#   }
# }

variable "bucket_name" {
  type    = string
  default = "ops-s3-scripts"
}

