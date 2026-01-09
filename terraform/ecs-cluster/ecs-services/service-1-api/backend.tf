terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "home-assig-remote-state"
    key     = "service-1-api/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
    profile = "SRE" # can't use var.profile here
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

