# This file manages application buckets only.
# Backend bucket (swetha-media-pipeline-2026) is bootstrapped manually and excluded.

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "swetha-lambda-code-2026"
  acl    = "private"

  tags = {
    Name        = "Lambda Code Bucket"
    Environment = "media-pipeline"
  }
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
