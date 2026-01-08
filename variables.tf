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

variable "project" {
  type    = string
  default = "media-pipeline"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    { description = "SSH", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "HTTP", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "Jenkins", from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "Grafana", from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "Prometheus", from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "NodeExporter", from_port = 9100, to_port = 9100, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

variable "ssh_public_key_path" {
  type    = string
  default = "C:/Users/Swetha/.ssh/id_rsa.pub"
}