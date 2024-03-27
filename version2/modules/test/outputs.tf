
output "created_by" {
  value = aws_vpc.vpc.tags.CreatedBy
}

output "environment" {
  value = aws_vpc.vpc.tags.Environment
}

output "vpc_name" {
  value = aws_vpc.vpc.tags.Name
}

output "prefix_map_public_subnets" {
  value = {
    for key, value in aws_subnet.public_subnet : key => value.id
  }
}

output "prefix_map_azs" {
  value = {
    for key, value in aws_subnet.public_subnet : key => value.availability_zone
  }
}

output "prefix_map_private_subnets" {
  value = {
    for key, value in aws_subnet.private_subnet : key => value.id
  }
}
