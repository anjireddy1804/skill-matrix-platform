output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "service_name" {
  description = "ECS service name when enabled."
  value       = try(aws_ecs_service.backend[0].name, null)
}

output "task_definition_arn" {
  description = "ECS task definition ARN when the service is enabled."
  value       = try(aws_ecs_task_definition.backend[0].arn, null)
}

output "task_definition_family" {
  description = "ECS task-definition family used by the backend deployment workflow."
  value       = "${var.project_name}-${var.environment}-backend"
}

output "container_name" {
  description = "Exact ECS container name used by the task definition."
  value       = "backend"
}

output "execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "ECS application task role ARN."
  value       = aws_iam_role.task.arn
}

output "log_group_name" {
  description = "CloudWatch log group name for backend ECS tasks."
  value       = aws_cloudwatch_log_group.backend.name
}
