variable "project_name" {
  description = "Project name used in ECS resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in ECS resource names and tags."
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the awslogs driver."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the Demo ECS service."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least two public subnet IDs are required for ECS."
  }
}

variable "security_group_id" {
  description = "ECS task security group ID."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for the backend container."
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR backend repository URL."
  type        = string
}

variable "backend_image_tag" {
  description = "Backend image tag. Use an immutable commit SHA tag for active services."
  type        = string
  default     = "latest"

  validation {
    condition     = trimspace(var.backend_image_tag) != ""
    error_message = "backend_image_tag must not be empty."
  }
}

variable "create_ecs_service" {
  description = "Whether to create the task definition and ECS service."
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Backend container port."
  type        = number
  default     = 8080
}

variable "ecs_cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 512
}

variable "ecs_memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 1024
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 1

  validation {
    condition     = var.ecs_desired_count >= 1
    error_message = "ecs_desired_count must be at least one when the service is enabled."
  }
}

variable "cloudwatch_log_retention" {
  description = "CloudWatch backend log retention in days."
  type        = number
  default     = 7

  validation {
    condition     = var.cloudwatch_log_retention > 0
    error_message = "cloudwatch_log_retention must be greater than zero."
  }
}

variable "database_endpoint" {
  description = "RDS endpoint hostname."
  type        = string
}

variable "database_port" {
  description = "RDS MySQL port."
  type        = number
  default     = 3306
}

variable "database_name" {
  description = "Application database name."
  type        = string
}

variable "database_username" {
  description = "Application database username."
  type        = string
}

variable "rds_master_secret_arn" {
  description = "RDS-managed master secret ARN."
  type        = string
}

variable "jwt_secret_arn" {
  description = "Application JWT secret ARN."
  type        = string
}

variable "cors_allowed_origins" {
  description = "Allowed browser origins passed to the backend as a comma-separated value."
  type        = list(string)

  validation {
    condition     = length(var.cors_allowed_origins) > 0 && alltrue([for origin in var.cors_allowed_origins : trimspace(origin) != "" && origin != "*"])
    error_message = "cors_allowed_origins must contain at least one non-wildcard origin."
  }
}

variable "common_tags" {
  description = "Common tags applied to ECS resources."
  type        = map(string)
  default     = {}
}
