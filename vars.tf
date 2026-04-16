variable "aws_key_pair_name" {
  description = "AWS key pair name"
  type        = string
}

variable "PUB_KEY_PATH" {
  description = "Path to public SSH key"
  type        = string
}

variable "PRIV_KEY_PATH" {
  description = "Path to private SSH key"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}