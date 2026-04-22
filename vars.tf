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
variable "VpcCIDR" {
  default = "172.21.0.0/16"
}
variable "PubSub1CIDR" {
  default = "172.21.1.0/24"
}

variable "PubSub2CIDR" {
  default = "172.21.2.0/24"
}

variable "PubSub3CIDR" {
  default = "172.21.3.0/24"
}

variable "PrivSub1CIDR" {
  default = "172.21.4.0/24"
}

variable "PrivSub2CIDR" {
  default = "172.21.5.0/24"
}

variable "PrivSub3CIDR" {
  default = "172.21.6.0/24"
}

variable "VPC_NAME" {
  default = "stefan-VPC"
}

variable "Zone1" {
  default = "us-east-1a"
}

variable "Zone2" {
  default = "us-east-1b"
}

variable "Zone3" {
  default = "us-east-1c"
}

variable "PROJECT" {
  default = "stefan-iac"
}

variable "my_ip" {
  default = "77.243.25.205/32"
}

variable "instance_count" {
  default = "1"
}

variable "dbname" {
  default = "accounts"
}
variable "dbuser" {
  default = "admin"
}
variable "dbpass" {
  default = "admin123"
}
