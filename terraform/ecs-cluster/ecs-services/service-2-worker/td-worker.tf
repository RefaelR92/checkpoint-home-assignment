resource "aws_ecs_task_definition" "worker" {
  family                   = "home-assign-worker"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  execution_role_arn = data.terraform_remote_state.ecs.outputs.ecs_execution_role_arn
  task_role_arn      = aws_iam_role.ecs_task_worker.arn

  container_definitions = jsonencode([
    {
      name      = "worker"
      image     = "${aws_ecr_repository.worker_repo.repository_url}:latest"
      essential = true

      memoryReservation = 256

      environment = [
        {
          name  = "SQS_QUEUE_URL"
          value = data.terraform_remote_state.sqs.outputs.queue_url
        },
        {
          name  = "S3_BUCKET"
          value = aws_s3_bucket.messages.bucket_domain_name
        },
        {
          name  = "S3_PREFIX"
          value = "messages/"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/home-assign-worker"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_iam_role" "ecs_task_worker" {
  name = "ecs-task-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_task_worker_policy" {
  role = aws_iam_role.ecs_task_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = data.terraform_remote_state.sqs.outputs.queue_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.messages.bucket_domain_name}/*"
      }
    ]
  })
}

