terraform {
  backend "s3" {
    bucket         = "swetha-media-pipeline-2026"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}