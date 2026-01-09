resource "aws_autoscaling_group" "ecs" {
  name                = "ecs-api-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-api-instance"
    propagate_at_launch = true
  }
}

