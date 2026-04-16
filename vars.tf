variable "aws_key_pair_name" {
  default = "iac-key-tf"
}
variable "PUB_KEY_PATH" {
  description = "Path to public SSH key"
  default     = "~/.ssh/iac-key-tf.pub"
}

variable "PRIV_KEY_PATH" {
  description = "Path to private SSH key"
  default     = "~/.ssh/iac-key-tf"
}

variable "region" {
  default = "us-east-1"
}