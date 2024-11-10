# output "health_check_id" {
#   value = aws_route53_health_check.health_check.id
# }

# output "sns_topic_arn" {
#   value = aws_sns_topic.alarm_topic.arn
# }


output "health_check_ids" {
  description = "Map of health check IDs for each endpoint"
  value       = merge(
                  { for k, v in aws_route53_health_check.health_check_str_match : k => v.id },
                  { for k, v in aws_route53_health_check.health_check_https : k => v.id }
                )
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for health check alerts"
  value       = aws_sns_topic.alarm_topic.arn
}
