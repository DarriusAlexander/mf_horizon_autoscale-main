#------------------------------------------------
# NginxPlus Provision
# - ec2 instance from marketplace
# - elb configuration
# - nginx.conf configuration
# - services.conf files in /et/nginx/conf.d/ 
#------------------------------------------------

data "aws_security_group" "selected_sg" {
  id = var.security_group_id
}

data "aws_vpc" "selected_vpc" {
  id = var.vpc_id
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_route53_record" "psa-internal" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "psa-int-qa.marinerfinance.io"
  type    = "A"
  ttl     = 300
  records = [aws_eip.lb.public_ip]
}

resource "aws_instance" "nginx_ec2" {
  ami           = "ami-0a85b249399765f47" # Nginx Plus AMI from AWS.MarketPlace 
  instance_type = "t3.large"
  key_name      = "ops_marinerfinance"
  tags = {
    Name        = "ngxPlus-ec2WF-nonProd"
    Environment = "NonProd"
  }
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  subnet_id              = var.public_subnet_id
  user_data              = file("boot.sh")
}

resource "aws_lb_target_group" "nginx_target_group" {
  name        = "ngxPlus-tg-nonProd"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected_vpc.id
  target_type = "instance"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "nginx_elb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_instance.nginx_ec2.id
  port             = 80
}

resource "aws_lb" "nginx_elb" {
  name               = "ngxPlus-elb-nonProd"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.selected_sg.id]
  subnets            = ["subnet-4744e90f", "subnet-4bbf5611"]

  enable_deletion_protection = false

  tags = {
    Environment = "QA"
  }
}

resource "aws_lb_listener" "nginx_elb_listener_443" {
  load_balancer_arn = aws_lb.nginx_elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_lb_listener" "nginx_elb_listener_80" {
  load_balancer_arn = aws_lb.nginx_elb.arn
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

