resource "aws_s3_bucket" "iac_bucket" {
  bucket = "stefan_iac_cicd_bucket"

  tags = {
    Name = "Stefan-IAC"
  }
}