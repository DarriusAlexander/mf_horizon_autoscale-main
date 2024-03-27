variable "global_default_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "aws access key"
  default     = false
}

variable "secret_key" {
  type        = string
  description = "ass secret key"
  default     = false
}
