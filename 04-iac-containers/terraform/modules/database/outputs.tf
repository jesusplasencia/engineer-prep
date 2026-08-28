output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "db_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.postgres.id
}

