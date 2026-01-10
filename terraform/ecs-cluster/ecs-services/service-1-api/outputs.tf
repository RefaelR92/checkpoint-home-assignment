output "ecr_api_repository_url" {
  value = aws_ecr_repository.api_repo.repository_url
}

output "test" {
  value = data.terraform_remote_state.ecs.outputs.elb_api_name
}

output "ssm_token_api_parameter_name" {
  value = aws_ssm_parameter.api_token.name
}
