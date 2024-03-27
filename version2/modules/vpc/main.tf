// VPC
// Public & Private Subnets
// Internet Gateway for Public Subnets
// Route Table
// Route for Internet Gateway
// Nat Gateway for Private Subnets
// Route Table for Nat Gateway
//
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-tf-${var.vpc_name}-${count.index + 1}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}


resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-tf-${var.vpc_name}-${count.index + 1}"
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

# Elastic Ip (eip) for NAT
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_eip.nat_eip]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)

  tags = {
    Name        = "nat-gatway-tf-${var.vpc_name}-${element(aws_subnet.public_subnets.*.id, 0)}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "rt-private-tf-${var.vpc_name}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "rt-public-tf-${var.vpc_name}"
    Environment = var.environment
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
    CreatedBy   = var.created_by
  }
}

resource "aws_route" "route_public_internet_gateway" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "route_private_internet_gateway" {
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

# Route table associations for both Public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.route_table_public.id
}

# Route table associations for Private subnet
resource "aws_route_table_association" "private" {
  # for_each = var.private_subnet_cidrs
  count     = length(var.private_subnet_cidrs)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  # subnet_id      = aws_subnet.private_subnets[each.value].id
  route_table_id = aws_route_table.route_table_private.id
}
