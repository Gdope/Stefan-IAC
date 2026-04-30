resource "aws_db_subnet_group" "stefan_rds_subgrp" {
  name       = "stefan_rds_subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "Subnet group for RDS"
  }
}

resource "aws_db_instance" "stefan_rds" {
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0.44"
  instance_class         = "db.t4g.micro"
  multi_az               = "false"
  publicly_accessible    = "false"
  parameter_group_name   = "default.mysql8.0"
  db_name                = var.dbname
  username               = var.dbuser
  password               = var.dbpass
  db_subnet_group_name   = aws_db_subnet_group.stefan_rds_subgrp.name
  vpc_security_group_ids = [aws_security_group.stefan_rds_sg.id]
  skip_final_snapshot    = true
}