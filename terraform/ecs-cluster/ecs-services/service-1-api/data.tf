data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    bucket  = "home-assig-remote-state"
    key     = "ecs/terraform.tfstate"
    region  = var.region
    profile = var.profile
  }
}
