variable "aws_key_pair_name" {
  description = "AWS key pair name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}