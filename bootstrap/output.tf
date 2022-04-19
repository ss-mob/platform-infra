output "bucket-name" {
  value       = aws_s3_bucket.terraform-state-bucket.id
  description = "Bucket name"
}

output "dynamo-db-name" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.id
  description = "Dynamo db name"
}