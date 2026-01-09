data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    bucket  = "home-assig-remote-state"
    key     = "ecs/terraform.tfstate"
    region  = var.region
    profile = var.profile
  }
}

data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket  = "home-assig-remote-state"
    key     = "messaging/sqs/terraform.tfstate"
    region  = "us-east-2"
    profile = var.profile
  }
}

