resource "aws_ssm_parameter" "api_token" {
  name  = "/home-assign/api/token"
  type  = "SecureString"
  value = random_password.api_token.result

  lifecycle {
    prevent_destroy = true
  }

}

resource "random_password" "api_token" {
  length  = 32
  special = true
}
