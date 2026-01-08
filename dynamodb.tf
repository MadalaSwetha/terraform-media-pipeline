resource "aws_dynamodb_table" "media_metadata" {
  name         = "media_metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_name"

  attribute {
    name = "file_name"
    type = "S"
  }

  tags = {
    Name    = "media_metadata"
    Project = "media-pipeline"
  }
}