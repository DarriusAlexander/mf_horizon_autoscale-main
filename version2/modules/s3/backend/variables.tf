#s3 bucket name
variable "bucket_name" {
  type        = string
  default     = ""
  description = "the bucket name that's being created"
}

#s3 bucket: force destroy
variable "force_destroy" {
  type        = bool
  default     = false
  description = "bucket force destroy"
}

#s3 bucket: block public acls
variable "block_public_acls" {
  type        = bool
  default     = false
  description = "bucket public acls"
}

#s3 bucket: block public policy
variable "block_public_policy" {
  type        = bool
  default     = false
  description = "bucket public policy"
}

#s3 bucket: ignore public acls
variable "ignore_public_acls" {
  type        = bool
  default     = false
  description = "ignore bucket public acls"
}


