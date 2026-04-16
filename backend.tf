terraform {
  backend "s3" {
    bucket = "stefan-iac-bucket"
    key = "terraform/backend"
    region = "us-east-1"
    
  }
}