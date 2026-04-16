variable "aws_key_pair_name" {
  description = "AWS key pair name"
  type        = string
  default     = "iac-key-tf"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}