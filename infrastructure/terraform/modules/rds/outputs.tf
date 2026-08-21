output "endpoint" {
  description = "RDS endpoint hostname for the future application connection string."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS MySQL port."
  value       = aws_db_instance.this.port
}

output "database_name" {
  description = "Initial database name created by RDS."
  value       = aws_db_instance.this.db_name
}

output "username" {
  description = "RDS master/application username."
  value       = aws_db_instance.this.username
}

output "master_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master credentials."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
