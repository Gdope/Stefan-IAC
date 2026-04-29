resource "aws_instance" "stefan_app01" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.iac_key_tf.key_name
  subnet_id                   = module.vpc.private_subnets[0]
  count                       = var.instance_count
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  iam_instance_profile = aws_iam_role_policy.app_profile.name
  user_data                   = file("scripts/user_data/app.sh")
  user_data_replace_on_change = true

  tags = {
    Name    = "stefan-app"
    Project = "stefan-IAC"
  }

  provisioner "file" {
    content = templatefile("templates/db-deploy.tmpl", {
      rds_endpoint = aws_db_instance.stefan_rds.address
      dbuser       = var.dbuser
      dbpass       = var.dbpass
    })

    destination = "/tmp/db-deploy.sh"

    connection {
      type                = "ssh"
      user                = var.USERNAME
      host                = self.private_ip
      private_key         = file(var.PRIV_KEY_PATH)
      bastion_host        = aws_instance.stefan_bastion_host[0].public_ip
      bastion_user        = var.USERNAME
      bastion_private_key = file(var.PRIV_KEY_PATH)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/db-deploy.sh",
      "sudo /tmp/db-deploy.sh"
    ]

    connection {
      type                = "ssh"
      user                = var.USERNAME
      host                = self.private_ip
      private_key         = file(var.PRIV_KEY_PATH)
      bastion_host        = aws_instance.stefan_bastion_host[0].public_ip
      bastion_user        = var.USERNAME
      bastion_private_key = file(var.PRIV_KEY_PATH)
    }
  }
}