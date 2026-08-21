output "vpc_id" {
  description = "Demo VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Demo public subnet IDs for future ALB/ECS resources."
  value       = module.network.public_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Demo private database subnet IDs for future RDS resources."
  value       = module.network.private_db_subnet_ids
}

output "availability_zones" {
  description = "Two availability zones selected for Demo."
  value       = module.network.availability_zones
}

output "internet_gateway_id" {
  description = "Demo VPC internet gateway ID."
  value       = module.network.internet_gateway_id
}

output "alb_security_group_id" {
  description = "Security group ID reserved for the future ALB."
  value       = module.security.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "Security group ID reserved for future ECS tasks."
  value       = module.security.ecs_security_group_id
}

output "rds_security_group_id" {
  description = "Security group ID reserved for the future RDS instance."
  value       = module.security.rds_security_group_id
}

output "ecr_repository_name" {
  description = "ECR backend repository name."
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR backend repository URL."
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR backend repository ARN."
  value       = module.ecr.repository_arn
}

output "rds_endpoint" {
  description = "Private RDS endpoint hostname for the future ECS application."
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "RDS MySQL port."
  value       = module.rds.port
}

output "rds_database_name" {
  description = "RDS database name for the future ECS application."
  value       = module.rds.database_name
}

output "rds_database_username" {
  description = "RDS master/application username for the future ECS application."
  value       = module.rds.username
}

output "rds_master_secret_arn" {
  description = "Secrets Manager ARN for RDS-managed master credentials."
  value       = module.rds.master_secret_arn
}

output "jwt_secret_arn" {
  description = "Secrets Manager ARN for the application JWT secret."
  value       = module.secrets.jwt_secret_arn
}

output "alb_arn" {
  description = "Application Load Balancer ARN."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "Backend target group ARN."
  value       = module.alb.target_group_arn
}

output "listener_arn" {
  description = "HTTP ALB listener ARN."
  value       = module.alb.listener_arn
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "ECS service name when enabled."
  value       = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN when the service is enabled."
  value       = module.ecs.task_definition_arn
}

output "ecs_task_definition_family" {
  description = "ECS task-definition family used by backend deployments."
  value       = module.ecs.task_definition_family
}

output "ecs_container_name" {
  description = "Exact ECS container name used by backend deployments."
  value       = module.ecs.container_name
}

output "ecs_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = module.ecs.execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ECS application task role ARN."
  value       = module.ecs.task_role_arn
}

output "backend_log_group_name" {
  description = "CloudWatch log group name for backend ECS tasks."
  value       = module.ecs.log_group_name
}

output "frontend_bucket_name" {
  description = "Private S3 bucket name for Angular artifacts."
  value       = module.frontend.bucket_name
}

output "frontend_bucket_arn" {
  description = "Private S3 bucket ARN for Angular artifacts."
  value       = module.frontend.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for frontend delivery."
  value       = module.frontend.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN for frontend delivery."
  value       = module.frontend.distribution_arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name."
  value       = module.frontend.domain_name
}

output "application_url" {
  description = "Public application URL using the default CloudFront certificate."
  value       = module.frontend.application_url
}

output "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = module.github_oidc.oidc_provider_arn
}

output "github_terraform_role_arn" {
  description = "GitHub Actions role for controlled Demo Terraform operations."
  value       = module.github_oidc.terraform_role_arn
}

output "github_application_role_arn" {
  description = "GitHub Actions role for Demo backend and frontend deployments."
  value       = module.github_oidc.application_role_arn
}

output "sns_topic_arn" {
  description = "SNS topic ARN used by Demo alarms."
  value       = module.observability.sns_topic_arn
}

output "cloudtrail_arn" {
  description = "CloudTrail management trail ARN."
  value       = module.audit.trail_arn
}

output "cloudtrail_log_bucket_name" {
  description = "Private S3 bucket storing CloudTrail logs."
  value       = module.audit.log_bucket_name
}

output "aws_budget_name" {
  description = "Monthly AWS budget name."
  value       = module.budget.budget_name
}
