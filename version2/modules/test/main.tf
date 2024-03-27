
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "internet-gateway-${var.vpc_name}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.prefix_map_public_subnet
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-tf-${var.vpc_name}-${each.value["az"]}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.prefix_map_private_subnet
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-tf-${var.vpc_name}-${each.value["az"]}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "ngw" {
  for_each = var.prefix_map_public_subnet

  depends_on    = [aws_eip.eip]
  allocation_id = aws_eip.eip.id

  subnet_id = element(aws_subnet.public_subnet.*.id, 0)
}
