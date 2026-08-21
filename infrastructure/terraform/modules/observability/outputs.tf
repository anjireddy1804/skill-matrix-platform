output "sns_topic_arn" {
  description = "SNS topic ARN used by Demo alarms."
  value       = aws_sns_topic.alerts.arn
}

output "sns_topic_name" {
  description = "SNS topic name used by Demo alarms."
  value       = aws_sns_topic.alerts.name
}
