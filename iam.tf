########################################
# IAM Role for Lambda
########################################
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

########################################
# IAM Policy Document
########################################
data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::swetha-media-pipeline-2026/lambda/media_lambda.zip"
    ]
  }

  statement {
    effect = "Allow"
    actions = ["dynamodb:PutItem"]
    resources = [
      "arn:aws:dynamodb:us-east-1:189023280243:table/media_metadata"
    ]
  }
}

########################################
# IAM Policy Resource
########################################
resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

########################################
# Attach Policy to Role
########################################
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}