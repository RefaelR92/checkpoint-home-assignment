output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}
output "elb_api_name" {
  value = aws_elb.api.name
}
