resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    elb_name       = aws_elb.api.name
    container_name = "api"
    container_port = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}

