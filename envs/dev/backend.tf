terraform {
  backend "s3" {
    bucket         = "terraform-state-sneha"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

