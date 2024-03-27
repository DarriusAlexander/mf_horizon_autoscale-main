variable "environment" {}
variable "sg_name" {}
variable "description" {}
variable "vpc_id" {}
variable "created_by" {}

# of type map
variable "sg_ingress" {}
variable "sg_egress" {}

# example:
# variable "example" {
#   type = map(object({
#     instance_type = string,
#     tags          = map(string)
#   }))
#   default = {
#     sandbox_one = {
#       instance_type = "t2.small"
#       tags = {
#         Name = "sandbox_one"
#       }
#     },
#     sandbox_two = {
#       instance_type = "t2.micro"
#       tags = {
#         Name = "sandbox_two"
#       }
#     },
#     sandbox_three = {
#       instance_type = "t2.nano"
#       tags = {
#         Name = "sandbox_three"
#       }
#     }
#   }
# }
