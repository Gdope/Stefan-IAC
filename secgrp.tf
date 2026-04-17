resource "aws_security_group" "stefan_elb_sg" {
  name        = "stefan-elb-sg-iac"
  description = "Load Balancer Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "elb-sg"
    ManagedBy = "terraform"
    Project   = "Stefan-IAC"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_forELB" {
  security_group_id = aws_security_group.stefan_elb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv4forELB" {
  security_group_id = aws_security_group.stefan_elb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv6forELB" {
  security_group_id = aws_security_group.stefan_elb_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "bastion_sg" {
  name        = "stefan-bastion-sg"
  description = "Jump server security group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "bastion-sg"
    ManagedBy = "terraform"
    Project   = "Stefan-IAC"
  }

}

resource "aws_vpc_security_group_ingress_rule" "ssh_my_ip" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv4_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv6_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "app_sg" {
  name        = "stefan-app-sg"
  description = "Application servers security group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "app-sg"
    ManagedBy = "terraform"
    Project   = "Stefan-IAC"
  }

}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_bastion" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTPfromELB" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.stefan_elb_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv4_app" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv6_app" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "backend_sg" {
  name        = "stefan-backend-sg"
  description = "Backend security group"
  vpc_id      = module.vpc.vpc_id


  tags = {
    Name      = "backend-sg"
    ManagedBy = "terraform"
    Project   = "Stefan-IAC"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_to_rmq" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 5672
  ip_protocol                  = "tcp"
  to_port                      = 5672
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_to_mc" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 11211
  ip_protocol                  = "tcp"
  to_port                      = 11211
}
resource "aws_vpc_security_group_ingress_rule" "all_traffic_from_itself" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.backend_sg.id
  ip_protocol                  = "-1"

}
resource "aws_vpc_security_group_ingress_rule" "all_traffic_from_app_sg" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  ip_protocol                  = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv4_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv6_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}



resource "aws_security_group" "rds_sg" {
  name        = "stefan-rds-sg"
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "rds-sg"
    ManagedBy = "terraform"
    Project   = "Stefan-IAC"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_to_mysql" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}
resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv4_rds" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_AllOutbound_ipv6_rds" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
