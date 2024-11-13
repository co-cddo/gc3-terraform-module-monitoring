resource "aws_sns_topic" "alarm_topic" {
  name = "${var.stack_name}-health-check-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_route53_health_check" "health_check_str_match" {
  for_each = { for i, endpoint in var.endpoints : i => endpoint if endpoint.type == "HTTPS_STR_MATCH" }

  fqdn              = var.fqdn
  type              = "HTTPS_STR_MATCH"
  port              = var.port
  resource_path     = each.value.resource_path
  request_interval  = each.value.request_interval
  failure_threshold = each.value.failure_threshold
  search_string     = each.value.search_string
  regions           = var.health_check_regions

  tags = {
    Name = "${var.stack_name}-health-check-${each.key}"
  }
}

resource "aws_route53_health_check" "health_check_https" {
  for_each = { for i, endpoint in var.endpoints : i => endpoint if endpoint.type == "HTTPS" }

  fqdn              = var.fqdn
  type              = "HTTPS"
  port              = var.port
  resource_path     = each.value.resource_path
  request_interval  = each.value.request_interval
  failure_threshold = each.value.failure_threshold
  regions           = var.health_check_regions

  tags = {
    Name = "${var.stack_name}-health-check-${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "health_check_alarm" {
  for_each = merge(
    aws_route53_health_check.health_check_str_match,
    aws_route53_health_check.health_check_https
  )

  alarm_name          = "${var.stack_name}-health-check-alarm-${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "This metric monitors route 53 healthchecks for ${var.fqdn} at ${each.value.resource_path}"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  ok_actions          = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    HealthCheckId = each.value.id
  }

  depends_on = [
    aws_route53_health_check.health_check_str_match,
    aws_route53_health_check.health_check_https
  ]
}