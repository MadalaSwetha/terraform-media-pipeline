output "s3_bucket_name" {
  value = aws_s3_bucket.media_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.media_metadata.name
}

output "lambda_function_name" {
  value = aws_lambda_function.media_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.media_lambda.arn
}