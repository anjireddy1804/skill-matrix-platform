output "repository_name" {
  description = "ECR repository name for the backend image."
  value       = aws_ecr_repository.backend.name
}

output "repository_arn" {
  description = "ECR repository ARN for the backend image."
  value       = aws_ecr_repository.backend.arn
}

output "repository_url" {
  description = "ECR repository URL for Docker push and pull operations."
  value       = aws_ecr_repository.backend.repository_url
}
