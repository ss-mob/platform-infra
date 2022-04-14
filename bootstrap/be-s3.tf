resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-tfstate"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-bucket-encryption" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket
  policy = data.aws_iam_policy_document.state-bucket-policy-doc.json
}

data "aws_iam_policy_document" "state-bucket-policy-doc" {
  statement {
    sid     = "StateBucketAccess"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.terraform-state-bucket.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.terraform-state-bucket.bucket}/*"
    ]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }
}