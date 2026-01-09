resource "aws_sqs_queue" "api_messages" {
  name                       = "home-assign-api-messages"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
}


