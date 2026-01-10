resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-api-"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t3.small"

  vpc_security_group_ids = [
    aws_security_group.ecs_instances.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
EOF
  )
}

