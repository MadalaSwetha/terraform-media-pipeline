terraform {
  backend "s3" {
    bucket       = "swetha-media-pipeline-2026"
    key          = "terraform.tfstate"
    region       = "us-east-1" # must match bucket’s actual region
    use_lockfile = true        # replaces dynamodb_table
  }
}