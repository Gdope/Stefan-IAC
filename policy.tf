resource "aws_iam_role" "app_role" {
  name = "app-s3-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "app_s3_read" {
  name = "app-s3-read-policy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject"
      ]
      Resource = "arn:aws:s3:::${var.artifact_bucket_name}/builds/*"
    }]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app-s3-read-profile"
  role = aws_iam_role.app_role.name
}