resource "aws_ecs_task_definition" "api" {
  family                   = "home-assign-api"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]


  # execution_role_arn = aws_iam_role.ecs_execution.arn
  execution_role_arn = data.terraform_remote_state.ecs.outputs.ecs_execution_role_arn
  task_role_arn      = aws_iam_role.ecs_task_api.arn

  container_definitions = jsonencode([
    {
      name              = "api"
      image             = "nginx:latest" # placeholder until app is ready
      essential         = true
      memoryReservation = 256


      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "SQS_QUEUE_URL"
          value = data.terraform_remote_state.sqs.outputs.queue_url
        },
        {
          name  = "TOKEN_SSM_PARAM"
          value = "/home-assign/api/token"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/home-assign-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_iam_role" "ecs_task_api" {
  name = "ecs-task-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

