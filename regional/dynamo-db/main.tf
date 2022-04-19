provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

resource "aws_dynamodb_table" "this" {
  name           = var.dynamodb-name
  billing_mode   = "PROVISIONED"
  read_capacity  = "5"
  write_capacity = "5"
  attribute {
    name = var.attribute-name
    type = "S"
  }
  hash_key = var.attribute-name
}
