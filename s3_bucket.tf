resource "aws_s3_bucket" "iac_bucket" {
  bucket = "stefan-iac-cicd-bucket"
  region = var.region

  tags = {
    Name = "Stefan-IAC"
  }
}