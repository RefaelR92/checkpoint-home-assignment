output "queue_url" {
  value = aws_sqs_queue.api_messages.id
}

output "queue_arn" {
  value = aws_sqs_queue.api_messages.arn
}

