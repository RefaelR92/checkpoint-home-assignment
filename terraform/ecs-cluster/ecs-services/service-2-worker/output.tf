
output "message_s3_bucket_name" {
  value = aws_s3_bucket.messages.bucket_domain_name
}
