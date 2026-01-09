resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    # elb_name       = aws_elb.api.name
    elb_name       = data.terraform_remote_state.ecs.outputs.elb_api_name
    container_name = "api"
    container_port = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}

