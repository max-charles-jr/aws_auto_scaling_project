terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-dev"
    key            = "web-app/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
