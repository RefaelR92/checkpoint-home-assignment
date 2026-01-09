data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "home-assig-remote-state"
    key     = "vpc/terraform.tfstate"
    region  = var.region
    profile = var.profile
  }
}


data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

