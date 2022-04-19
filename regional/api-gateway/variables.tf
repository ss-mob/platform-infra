variable "region" {
  description = "AWS region name"
}

variable "aws_profile" {
  description = "AWS profile name"
}

variable "api_gw_name" {
  description = "API gateway name"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "sub_domain_name" {
  description = "Custom domain name"
  type        = string
}

variable "retention_in_days" {
  description = "Cloudwatch retention period"
  type        = number
}

variable "stages" {
  description = "Name of stages"
  type        = list(string)
}