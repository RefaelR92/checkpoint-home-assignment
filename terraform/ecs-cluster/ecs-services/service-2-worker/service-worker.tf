resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.worker.arn
  desired_count   = 1
  launch_type     = "EC2"

  scheduling_strategy = "REPLICA"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
}

