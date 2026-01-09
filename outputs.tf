########################################
# Output: S3 Bucket Name
########################################
output "s3_media_bucket_name" {
  description = "Name of the S3 bucket used for media uploads"
  value       = aws_s3_bucket.media_bucket.bucket
}

########################################
# Output: Lambda Function Name
########################################
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.media_lambda.function_name
}

########################################
# Output: Lambda Function ARN
########################################
output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.media_lambda.arn
}

########################################
# Output: IAM Role ARN
########################################
output "lambda_exec_role_arn" {
  description = "ARN of the IAM role used by Lambda"
  value       = aws_iam_role.lambda_exec.arn
}
