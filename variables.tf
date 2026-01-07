variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "swetha-media-pipeline-2026"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "media_metadata"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "media_pipeline_lambda"
}