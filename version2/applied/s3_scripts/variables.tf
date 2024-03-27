variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

variable "environment" {
  type    = string
  default = "Ops"
}

variable "bucket_name" {
  type    = string
  default = "ops-s3-scripts"
}

variable "force_destroy" {
  type    = bool
  default = false
}
variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}
variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "status" {
  type    = string
  default = "Enabled"
}

variable "created_by" {
  type    = string
  default = "dev_ops"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "prevent_destroy" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "fileset" {
  default = "./files"
}

variable "vpce_id" {
  type    = string
  default = "vpce-0918a86e370a2197a"
}
