output "health_check_id" {
  value = aws_route53_health_check.health_check.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}
