provider "aws" {
  region = "us-east-1"
  profile = "default"
}

module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "my-dev-bucket-sneha"
  tags        = {
    Environment = "dev"
  }
}
