#---------------------------------------
# DevOps - ec2
# Path: version2/legacy/dev_domain/
# Date: 01/25/24
#---------------------------------------

# Refer to the template file - install_nginx.sh
# data "template_file" "user_data" {
#   template = file("base_boot.sh")
#   vars = {
#     currentYear = "2023"
#   }
# }

data "aws_route53_zone" "dev_domain" {
  name         = var.hostname
  private_zone = false
}

data "aws_security_group" "selected_sg" {
  id = var.security_group_id
}

data "aws_vpc" "selected_vpc" {
  id = var.vpc_id
}

data "aws_iam_instance_profile" "existing_role" {
  name = var.existing_role
}

terraform {
  # required_version = "~> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "mariner"
  region                   = var.aws_region
}

# Push statefile to s3_bucket
terraform {
  backend "s3" {
    # bucket name must be declared
    bucket         = "mf-s3-tf-statefiles"
    key            = "legacy/dev_domain/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mf-tf-locks"
    encrypt        = true
  }
}

resource "aws_route53_record" "dev_domain" {
  for_each        = var.domains
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.dev_domain.zone_id
  name            = each.value
  type            = "A"

  alias {
    name                   = aws_lb.dev_domain_elb.dns_name
    zone_id                = aws_lb.dev_domain_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dev_domain_internal" {
  for_each        = var.domains_internal
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.dev_domain.zone_id
  name            = each.value
  type            = "A"
  ttl             = 300
  records         = [aws_instance.dev_domain.private_ip]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.dev_domain.id
  allocation_id = aws_eip.dev_domain.id
}

resource "aws_eip" "dev_domain" {
  instance = aws_instance.dev_domain.id
  domain   = "vpc"
}

resource "aws_instance" "dev_domain" {

  # ami                  = "ami-09e67e426f25ce0d7" # Nginx Plus AMI from AWS.MarketPlace 

  # ami: ami-0b2d926bf00e3758f
  # used_by: [ PSA_QA ]
  # operating_system: ubuntu 22.04.3 LTS
  # kernel: linux 5.15.0-051500rc7-generic
  ami                  = "ami-0a9c8c2fc4b7cd513"
  iam_instance_profile = data.aws_iam_instance_profile.existing_role.name
  instance_type        = "c5.4xlarge"
  key_name             = "ops_marinerfinance"
  tags = {
    Name        = "Dev-Domain"
    Environment = "Dev"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 200
  }

  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  subnet_id              = var.public_az1_subnet_id
  # user_data              = file("boot.sh")
  # user_data : render the template
  # user_data = data.template_file.user_data.rendered
}

resource "aws_lb_target_group" "dev_domain_target_group" {
  name        = "dev-domain-tg-nonProd"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.selected_vpc.id
  target_type = "instance"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 10
    unhealthy_threshold = 5
  }
}

resource "aws_lb_target_group_attachment" "dev_domain_elb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.dev_domain_target_group.arn
  target_id        = aws_instance.dev_domain.id
  port             = 443
}

resource "aws_lb" "dev_domain_elb" {
  name               = "dev-domain-elb-nonProd"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.selected_sg.id]
  # make sure to add the right subnets
  subnets = [var.public_az1_subnet_id, var.public_az2_subnet_id]

  enable_deletion_protection = false

  tags = {
    Environment = "Dev"
  }
}
# handles inbound request on port 443
resource "aws_lb_listener" "dev_domain_elb_listener_443" {
  load_balancer_arn = aws_lb.dev_domain_elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_domain_target_group.arn
  }
}

resource "aws_lb_listener_certificate" "cert" {
  listener_arn    = aws_lb_listener.dev_domain_elb_listener_443.arn
  certificate_arn = var.ssl_cert
}
# redirects traffic from port 80 to 443
resource "aws_lb_listener" "dev_domain_elb_listener_80" {
  load_balancer_arn = aws_lb.dev_domain_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
