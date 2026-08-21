output "alb_security_group_id" {
  description = "Security group ID for the future ALB."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group ID for future ECS tasks."
  value       = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  description = "Security group ID for the future RDS instance."
  value       = aws_security_group.rds.id
}
