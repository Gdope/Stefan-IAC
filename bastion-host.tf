data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "stefan_bastion_host" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.iac_key_tf.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]


  tags = {
    Name = "stefan-bastion-host"

  }
}
resource "aws_instance" "stefan_mc01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.iac_key_tf.key_name
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  user_data              = file("${path.module}/user_data/memcached.sh")

  tags = {
    Name = "stefan-memcached"

  }

}
resource "aws_instance" "stefan_rmq01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.iac_key_tf.key_name
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  user_data              = file("${path.module}/user_data/rabbitmq.sh")

  tags = {
    Name = "stefan-rabbitmq"

  }

}
resource "aws_instance" "stefan_app01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.iac_key_tf.key_name
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = file("${path.module}/user_data/app.sh")

  tags = {
    Name = "stefan-app"

  }

}

