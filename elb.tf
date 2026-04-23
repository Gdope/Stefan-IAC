module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name               = "stefan-alb"
  load_balancer_type = "application"
  internal           = false

  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
  security_groups = [aws_security_group.stefan_elb_sg.id]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "app_tg"
      }
    }
  }

  target_groups = {
    app_tg = {
      name_prefix       = "app-"
      protocol          = "HTTP"
      port              = 8080
      target_type       = "instance"
      target_id         = aws_instance.stefan_app01[0].id
      create_attachment = true

      health_check = {
        enabled             = true
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = "200-399"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        timeout             = 5
      }
    }
  }

  tags = {
    Project = "Stefan-IAC"
  }
}