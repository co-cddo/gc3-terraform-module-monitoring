variable "fqdn" {
  description = "The FQDN of the health check"
  type        = string
}

variable "port" {
  description = "The port number for the health check"
  type        = number
}

variable "health_check_regions" {
  description = "Regions where the health check is monitored"
  type        = list(string)
  default     = ["us-west-1", "us-west-2", "eu-west-1"]
}

variable "email" {
  description = "The email to send alerts to"
  type        = string
}


variable "endpoints" {
  description = "List of endpoint configurations"
  type = list(object({
    resource_path     = string
    search_string     = string
    request_interval  = number
    failure_threshold = number
    type              = string  # Either "HTTPS" or "HTTPS_STR_MATCH"
  }))
}

locals {
  service_name   = "webcaf"
  service_name_w = "webcaf-${terraform.workspace}"
}