resource "aws_route53_health_check" "health_check" {
  fqdn              = var.fqdn
  type              = "HTTPS_STR_MATCH"
  port              = var.port
  resource_path     = var.resource_path
  request_interval  = var.request_interval
  failure_threshold = var.failure_threshold
  search_string     = var.search_string
  regions           = var.health_check_regions
  # cloudwatch_alarm_name = aws_cloudwatch_metric_alarm.health_check_alarm.name
  # cloudwatch_alarm_region = "eu-west-1"  

  tags = {
    Name =  "${local.service_name_w}-health-check"
  }

}

resource "aws_sns_topic" "alarm_topic" {
  name = "${local.service_name_w}-health-check-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}


resource "aws_cloudwatch_metric_alarm" "health_check_alarm" {
  alarm_name          = "${local.service_name_w}-health-check-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "This metric monitors route 53 healthchecks"
  actions_enabled     = "true"
  alarm_actions = [
    aws_sns_topic.alarm_topic.arn
  ]
  ok_actions = [
    aws_sns_topic.alarm_topic.arn
  ]
  # treat_missing_data  = "breaching"
  dimensions = {
      HealthCheckId = aws_route53_health_check.health_check.id
   }
  depends_on = [
     aws_route53_health_check.health_check,
     aws_sns_topic.alarm_topic
    ]
}