########################################
# EC2 / Monitoring Outputs
########################################
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance running Jenkins/Grafana/Prometheus"
  value       = aws_instance.jenkins_host.public_ip
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${aws_instance.jenkins_host.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus metrics endpoint"
  value       = "http://${aws_instance.jenkins_host.public_ip}:9090"
}

output "jenkins_url" {
  description = "Jenkins CI/CD URL"
  value       = "http://${aws_instance.jenkins_host.public_ip}:8080"
}

########################################
# S3 / Lambda Outputs
########################################
output "s3_media_bucket_name" {
  description = "Name of the S3 bucket for media data"
  value       = aws_s3_bucket.media_bucket.bucket
}

output "s3_lambda_bucket_name" {
  description = "Name of the S3 bucket for Lambda deployment packages"
  value       = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.media_lambda.function_name
}