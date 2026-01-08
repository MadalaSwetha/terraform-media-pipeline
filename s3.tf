########################################
# Application Data Bucket (media_bucket)
########################################
resource "aws_s3_bucket" "media_bucket" {
  bucket = "swetha-media-pipeline-2026"

  tags = {
    Name    = "media_bucket"
    Project = "media-pipeline"
  }

  force_destroy = true
}

resource "aws_s3_bucket_versioning" "media_bucket_versioning" {
  bucket = aws_s3_bucket.media_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "media_bucket_encryption" {
  bucket = aws_s3_bucket.media_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

########################################
# Lambda Deployment Bucket (lambda_bucket)
########################################
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "swetha-lambda-code-2026"

  tags = {
    Name    = "lambda_bucket"
    Project = "media-pipeline"
  }

  force_destroy = true
}

########################################
# Lambda Function referencing S3 bucket
########################################
resource "aws_lambda_function" "media_lambda" {
  function_name = "media_lambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "lambda/media_lambda.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn

  depends_on = [aws_iam_role.lambda_role]

  tags = {
    Name    = "media_lambda"
    Project = "media-pipeline"
  }
}