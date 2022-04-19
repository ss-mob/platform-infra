variable "region" {
  description = "AWS region name"
}

variable "aws_profile" {
  description = "AWS profile name"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "subject_alternative_names" {
  description = "Alternative domain names"
  type        = list(string)
  default     = null
}
