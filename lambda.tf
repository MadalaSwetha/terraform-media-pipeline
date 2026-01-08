resource "aws_lambda_function" "media_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename = "lambda_function.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.media_metadata.name
    }
  }

  tags = {
    Project = "media-pipeline"
  }
}

# Allow S3 bucket to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.media_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.media_bucket.arn
}

# S3 bucket notification wired to Lambda
resource "aws_s3_bucket_notification" "bucket_notify" {
  bucket = aws_s3_bucket.media_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.media_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_function.media_lambda,
    aws_lambda_permission.allow_s3
  ]
}