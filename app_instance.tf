resource "aws_instance" "stefan_app01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.iac_key_tf.key_name
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = file("scripts/user_data/app.sh")

  tags = {
    Name = "stefan-app"

  }

}
