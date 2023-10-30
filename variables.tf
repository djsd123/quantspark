variable "name" {
  type = string

  default     = "quantspark"
  description = "The common name for all resources"
}

variable "zone_id" {
  type = string

  description = "The ID of the AWS route53 zone you want to use with this deployment"

  validation {
    condition     = length(regexall("[A-Z0-9]{8,32}", var.zone_id)) == 1
    error_message = "Route53 zone Ids are alpha numeric and must be between 8-32 characters long."
  }
}
