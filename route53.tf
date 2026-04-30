module "private_zone" {
  source = "terraform-aws-modules/route53/aws"

  name    = "internal"
  comment = "Private hosted zone for internal communication"

  vpc = {
    one = {
      vpc_id     = module.vpc.vpc_id
      vpc_region = var.region
    }
  }

  records = {
    app = {
      name    = "app"
      type    = "A"
      ttl     = 300
      records = [aws_instance.stefan_app01[0].private_ip]
    }

    rmq = {
      name    = "rmq"
      type    = "A"
      ttl     = 300
      records = [aws_instance.stefan_rmq01[0].private_ip]
    }

    mc = {
      name    = "mc"
      type    = "A"
      ttl     = 300
      records = [aws_instance.stefan_mc01[0].private_ip]
    }
  }

  tags = {
    Project = "Stefan-IAC"
  }
}