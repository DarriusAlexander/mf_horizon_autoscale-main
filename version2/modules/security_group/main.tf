resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id
  tags = {
    Name        = var.sg_name
    Environment = var.environment
    CreatedBy   = var.created_by
    CreateDate  = formatdate("EEEE, DD-MMM-YY hh:mm:ss ZZZ", timestamp())
  }

}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  security_group_id = aws_security_group.sg.id

  for_each    = var.sg_ingress
  cidr_ipv4   = each.value["cidr_ipv4"]
  from_port   = each.value["from_port"]
  ip_protocol = each.value["ip_protocol"]
  to_port     = each.value["to_port"]
}

resource "aws_vpc_security_group_egress_rule" "sg_egress" {
  security_group_id = aws_security_group.sg.id

  for_each    = var.sg_egress
  cidr_ipv4   = each.value["cidr_ipv4"]
  ip_protocol = each.value["ip_protocol"]
}


