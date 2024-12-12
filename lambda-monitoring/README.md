# Lambda Monitoring Module

This Terraform module, **lambda-monitoring**, is designed to set up AWS monitoring and reporting for a lambda mfunction. It includes functionality for lambda and CloudWatch alarms. 

## Features

- **SNS Alerts**: A single SNS topic that sends notifications to a specified email when health checks fail.
- **CloudWatch Alarms**: Monitors health check statuses and triggers alerts via SNS.

## Usage

### Example Usage

```hcl

locals {
  lambda_name = "lambda-dev"
}
module "lambda_monitoring" {
  source             = "git@github.com/co-cddo/gc3-terraform-module-monitoring.git//lambda-monitoring:lambda-monitoring?ref=v1.0.0"
  lambda_name        = local.lambda_name
  statistic          = "Sum"
  alarm_description  = "Alarm for Lambda function errors exceeding threshold"
  alarm_name         = "${local.lambda_name}-Lambda-Alarm"
  topic_subscription = "alerting@example.com""
}


output "cloudwatch_alarm_arn" {
  value = module.lambda_monitoring."alerting@example.com"
}

```

### Required Variables

- **`lambda_name`** (string): Required : A unique name for the alarm.
- **`alarm_name`** (string): Required: The descriptive name for the alarm. This name must be unique within the user's AWS account.
- **`metric_name`** (string): Required : The name for the alarm's associated metric.
- **`topic_subscription`** (string): Required : Endpoint to send data to. For email this is the email address.

### Optional Variables

- **`comparison_operator`** (string): Default **GreaterThanOrEqualToThreshold** : The arithmetic operation to use when comparing the specified Statistic and Threshold.
- **`evaluation_periods`** (number): Default **1** : The number of periods over which data is compared to the specified threshold. 
- **`namespace`** (string): Default **AWS/Lambda** : The namespace for the alarm's associated metric.
- **`period`** (string): Default **3** : The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60
- **`statistic`** (string): Default **Sum** : The statistic to apply to the alarm's associated metric. i.e. SampleCount, Average, Sum, Minimum, Maximum
- **`threshold`** (number): Default **3** : The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds.
- **`insufficient_data_actions`** (list(string)): Default **[]** : (Optional) The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state.
- **`treat_missing_data`** (string): (Optional): Default **missing** : Sets how this alarm is to handle missing data points.
- **`alarm_description`** (string): (Optional): Default **Alarm for Lambda function errors exceeding threshold** : 

- **`protocol`** (string): Default **email** : Protocol to use.

### Outputs

- **`cloudwatch_alarm_arn`** : arn of the aws cloudwatch alarm 
