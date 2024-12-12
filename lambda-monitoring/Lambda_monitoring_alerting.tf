variable "lambda_name" {
  type    = string
  default = ""
}
variable "alarm_threshold" {
  type    = number
  default = 3
}
variable "alarm_period" {
  type    = number
  default = 300
}
variable "evaluation_periods" {
  type    = number
  default = 1
}
variable "statistic" {
  type    = string
  default = "Sum"
}
variable "alarm_actions" {
  type    = string
  default = ""
}
variable "ok_actions" {
  type    = string
  default = ""
}
variable "treat_missing_data" {
  type    = string
  default = "notBreaching"
}
variable "insufficient_data_actions" {
  type    = list(string)
  default = []
}
variable "alarm_description" {
  type    = string
  default = "Alarm for Lambda function errors exceeding threshold"
}
variable "comparison_operator" {
  type = string
  default = "GreaterThanOrEqualToThreshold"
}
variable "metric_name" {
  type = string
  default = "Lambda-Errors"
}
variable "namespace" {
  type = string
  default = "AWS/Lambda"
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name                = "${var.lambda_name}-Error-Alarm"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.alarm_period
  statistic                 = var.statistic
  threshold                 = var.alarm_threshold
  alarm_actions             = [aws_sns_topic.lambda_alarm_topic.arn]
  ok_actions                = [aws_sns_topic.lambda_alarm_topic.arn]
  insufficient_data_actions = var.insufficient_data_actions
  treat_missing_data        = var.treat_missing_data
  alarm_description         = var.alarm_description
  dimensions                = { 
    FunctionName            = var.lambda_name
  }
}

variable "topic_subscription" {
  type = string
  default = "lambda-error-notifications"
}
variable "alarm_name" {
  type = string
  default = ""
}
variable "protocol" {
  type    = string
  default = "email"
}

resource "aws_sns_topic" "lambda_alarm_topic" {
  name = var.alarm_name
}
resource "aws_sns_topic_subscription" "lambda_alarm_subscription" {
  topic_arn = aws_sns_topic.lambda_alarm_topic.arn
  protocol  = var.protocol
  endpoint  = var.topic_subscription
}

output "cloudwatch_alarm_arn" {
  description = "The ARN of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.lambda_error_alarm.arn
}
