output "vpc" {
  value       = module.aws_vpc.vpc.id
  description = "the vpc Id"
}
