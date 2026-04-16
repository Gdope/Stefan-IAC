resource "aws_key_pair" "iac_key_tf" {
  key_name   = var.aws_key_pair_name
  public_key = file(pathexpand(var.PUB_KEY_PATH))
}