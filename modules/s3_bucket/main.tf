provider "aws" {
  region = "us-east-1"
  profile = "default"
}


resources "aws_s3_bucket" "bucket" {
    bucket = var.bucket
    tags = var.tags
}