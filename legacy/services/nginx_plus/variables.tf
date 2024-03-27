# AWS REGION
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "the aws region"
}

# AWS ACCESS_KEY  
variable "access_key" {
  type        = string
  default     = ""
  description = "the IAM access key"
}
# AWS ACCESS_SECRET  
variable "secret_key" {
  type        = string
  default     = ""
  description = "the IAM secret key"
}
# Environment : QA
variable "environment" {
  type    = string
  default = "qa"
}
# VPC_Peering : [Development, STAGING]
# define the VPC 
variable "vpc_id" {
  type        = string
  default     = "vpc-e5bfa583"
  description = "marinerfinance.vpc.qa"
}

variable "public_subnet_id" {
  type        = string
  default     = "subnet-4744e90f"
  description = "marinerfinance.vpc.public_subnet_id"
}


# Environment: QA
# SecurityGroup: MSG_QA
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
# print the instance's ip address
output "public_ipv4_address" {
  value = aws_instance.qa_domain_ec2.public_ip
}


