output "jwt_secret_arn" {
  description = "Secrets Manager ARN containing the generated application JWT secret."
  value       = aws_secretsmanager_secret.jwt.arn
}
