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