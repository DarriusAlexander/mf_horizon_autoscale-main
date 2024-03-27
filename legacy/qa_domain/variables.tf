# Environment : QA
variable "environment" {
  type    = string
  default = "qa"
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

# VPC_Peering : [qaelopment, STAGING]
# define the VPC 
variable "vpc_id" {
  type        = string
  default     = "vpc-e5bfa583"
  description = "marinerfinance.vpc.qa"
}

variable "public_az1_subnet_id" {
  type        = string
  default     = "subnet-4744e90f"
  description = "marinerfinance.vpc.public_az1_subnet_id"
}

variable "public_az2_subnet_id" {
  type        = string
  default     = "subnet-4bbf5611"
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

# Environment: qaE
# SecurityGroup: MSG_qa
variable "security_group_id" {
  type        = string
  default     = "sg-0f65afe45bbafe13f"
  description = "marinerfinance.securitygroup.qa"
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
    "cac-integration-qa.marinerfinance.io",
    "msa-integration-qa.marinerfinance.io",
    "psa-integration-qa.marinerfinance.io",
    "dsa-integration-qa.marinerfinance.io",
    "esa-integration-qa.marinerfinance.io",
    "jsa-integration-qa.marinerfinance.io",
    "dcp-integration-qa.marinerfinance.io"
  ]
}
variable "domains_internal" {
  type = set(string)
  default = [
    "psa-integration-qa-internal.marinerfinance.io",
    "dsa-integration-qa-internal.marinerfinance.io",
    "esa-integration-qa-internal.marinerfinance.io",
    "jsa-integration-qa-internal.marinerfinance.io",
    "dcp-integration-qa-internal.marinerfinance.io"
  ]
}
# variable "domain_names" {
#   type = map(object({
#     name = string
#   }))
#   default = {
#     dns_one = {
#       name = "cac.integration.qa.marinerfinance.io"
#     }
#   }
# }

variable "bucket_name" {
  type    = string
  default = "ops-s3-scripts"
}

