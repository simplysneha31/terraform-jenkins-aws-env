provider "aws" {
  region = "us-east-1"
  profile = "default"
}


resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket
    tags = var.tags
}