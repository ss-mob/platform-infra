provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
  required_version = "~> 1.0.1"
}

data "aws_caller_identity" "current" {}