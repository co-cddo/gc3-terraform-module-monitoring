
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name                = var.alarm_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_actions             = [aws_sns_topic.lambda_alarm_topic.arn]
  ok_actions                = [aws_sns_topic.lambda_alarm_topic.arn]
  insufficient_data_actions = var.insufficient_data_actions
  treat_missing_data        = var.treat_missing_data
  alarm_description         = var.alarm_description
  dimensions                = { 
    FunctionName            = var.lambda_name
  }
}

resource "aws_sns_topic" "lambda_alarm_topic" {
  name = var.alarm_name
}
resource "aws_sns_topic_subscription" "lambda_alarm_subscription" {
  topic_arn = aws_sns_topic.lambda_alarm_topic.arn
  protocol  = var.protocol
  endpoint  = var.topic_subscription
}


