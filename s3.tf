########################################
# S3 Bucket for media uploads
########################################
resource "aws_s3_bucket" "media_bucket" {
  bucket = "swetha-media-pipeline-2026"

  tags = {
    Name        = "Media Upload Bucket"
    Environment = "media-pipeline"
  }
}

########################################
# Lambda Function
########################################
resource "aws_lambda_function" "media_lambda" {
  function_name    = "media_lambda"
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_exec.arn

  # Deployment package stored in S3
  s3_bucket        = aws_s3_bucket.media_bucket.bucket
  s3_key           = "lambda/media_lambda.zip"

  timeout          = 10
  memory_size      = 128
}

########################################
# Lambda Permission (allow S3 to invoke)
########################################
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.media_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.media_bucket.arn
}

########################################
# S3 Bucket Notification (trigger Lambda)
########################################
resource "aws_s3_bucket_notification" "media_bucket_notify" {
  bucket = aws_s3_bucket.media_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.media_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}