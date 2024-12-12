variable "lambda_name" {
  type    = string
}
variable "alarm_name" {
  type    = string
}
variable "comparison_operator" {
  type = string
  default = "GreaterThanOrEqualToThreshold"
}
variable "evaluation_periods" {
  type    = number
  default = 1
}
variable "metric_name" {
  type = string
}
variable "namespace" {
  type = string
  default = "AWS/Lambda"
}
variable "period" {
  type    = number
  default = 300
}
variable "statistic" {
  type    = string
  default = "Sum"
}
variable "threshold" {
  type    = number
  default = 3
}
variable "insufficient_data_actions" {
  type    = list(string)
  default = []
}
variable "treat_missing_data" {
  type    = string
  default = "notBreaching"
}
variable "alarm_description" {
  type    = string
  default = "Alarm for Lambda function errors exceeding threshold"
}

variable "protocol" {
  type    = string
  default = "email"
}
variable "topic_subscription" {
  type = string
  default = "lambda-error-notifications"
}