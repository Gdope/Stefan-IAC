terraform {
  backend "s3" {
    bucket = "stefan-IAC-bucket"
    key = "terraform/backend"
    region = "us-east-1"
    
  }
}