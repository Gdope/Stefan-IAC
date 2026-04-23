output "RDSEndpoint" {
  description = "RDS Endpoint"
  value = aws_db_instance.stefan_rds.endpoint
}