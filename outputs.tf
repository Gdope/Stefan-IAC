output "RDSEndpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.stefan_rds.endpoint
}
output "bastion_public_ip" {
  value = aws_instance.stefan_bastion_host[0].public_ip
}

output "app_private_ip" {
  value = aws_instance.stefan_app01[0].private_ip
}