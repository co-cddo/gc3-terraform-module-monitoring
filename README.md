# gc3-tf-module-monitoring

# Basic Monitoring Module

This Terraform module, **basic-monitoring**, is designed to set up AWS monitoring for specified endpoints. It includes functionality for Route 53 health checks, SNS alerts, and CloudWatch alarms. This module supports both `HTTPS` and `HTTPS_STR_MATCH` checks, allowing configuration of various endpoints with customizable settings.

## Features

- **Route 53 Health Checks**: Configurable health checks for multiple endpoints, supporting both HTTPS-only and HTTPS with string matching.
- **SNS Alerts**: A single SNS topic that sends notifications to a specified email when health checks fail.
- **CloudWatch Alarms**: Monitors health check statuses and triggers alerts via SNS.

## Usage

### Example Usage

```hcl
module "myapp_health_check" {
  source = "git::https://github.com/co-cddo/gccc-tf-module-monitoring.git//basic-monitoring?ref=v1.0.1"

  fqdn   = "example.com"
  port   = 443
  health_check_regions = ["us-west-1", "us-west-2", "eu-west-1"]
  endpoints = [
    {
      resource_path     = "/apitest"
      search_string     = "APITEST:OK"
      request_interval  = 30
      failure_threshold = 1
      type              = "HTTPS_STR_MATCH"
    },
    {
      resource_path     = "/health"
      search_string     = ""  # No search string, so will use HTTPS only
      request_interval  = 30
      failure_threshold = 1
      type              = "HTTPS"
    }
  ]
  email = "alerting@example.com"
}

output "health_check_ids" {
  value = module.myapp_health_check.health_check_ids
}

output "sns_topic_arn" {
  value = module.myapp_health_check.sns_topic_arn
}
```

### Required Variables

- **`fqdn`** (string): The fully qualified domain name (FQDN) for the health checks.
- **`port`** (number): The port number for health checks (e.g., 443 for HTTPS).
- **`health_check_regions`** (list(string)): List of AWS regions where health checks should be monitored. Default regions are `["us-west-1", "us-west-2", "eu-west-1"]`.
- **`email`** (string): The email address to send SNS alerts.
- **`endpoints`** (list(object)):
  - **`resource_path`** (string): The path on the FQDN to be checked.
  - **`search_string`** (string): The expected response string (only required for `HTTPS_STR_MATCH` checks; leave blank for `HTTPS` checks).
  - **`request_interval`** (number): The interval in seconds between health check requests.
  - **`failure_threshold`** (number): The number of consecutive health check failures required to trigger an alert.
  - **`type`** (string): Specifies the type of health check. Use `"HTTPS"` for HTTPS checks and `"HTTPS_STR_MATCH"` for HTTPS checks with a required string match.

### Outputs

- **`health_check_ids`** (map): A map of health check IDs for each configured endpoint.
- **`sns_topic_arn`** (string): ARN of the SNS topic used for health check alerts.

# Lambda Monitoring Module

This Terraform module, **lambda-monitoring**, is designed to set up AWS monitoring and reporting for a lambda mfunction. It includes functionality for lambda and CloudWatch alarms. 

## Features

- **SNS Alerts**: A single SNS topic that sends notifications to a specified email when health checks fail.
- **CloudWatch Alarms**: Monitors health check statuses and triggers alerts via SNS.

## Documentation

Refer to the README.md in the lambda-monitoring folder for a detailed description.

