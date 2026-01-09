resource "aws_elb" "api" {
  name = "home-assign-api-elb"

  subnets = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  security_groups = [
    aws_security_group.elb.id
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  cross_zone_load_balancing = true
  idle_timeout              = 60

  tags = {
    Name = "home-assign-api-elb"
  }
}

resource "aws_security_group" "elb" {
  name   = "api-elb-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "api-elb-sg"
  }
}

