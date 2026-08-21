variable "project_name" {
  description = "Project name used in resource names and tags."
  type        = string
  default     = "skill-matrix"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "project_name must contain lowercase letters, numbers, and hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "demo"

  validation {
    condition     = var.environment == "demo"
    error_message = "This root configuration is for the demo environment."
  }
}

variable "aws_region" {
  description = "AWS region for the Demo environment."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the Demo VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public ALB/ECS subnets."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the two private database subnets."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDRs are required."
  }
}

variable "container_port" {
  description = "Backend container and ALB target port."
  type        = number
  default     = 8080

  validation {
    condition     = var.container_port > 0 && var.container_port < 65536
    error_message = "container_port must be a valid TCP port."
  }
}

variable "health_check_path" {
  description = "ALB health-check path for the Spring Boot backend."
  type        = string
  default     = "/actuator/health"
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
  description = "Desired number of Fargate tasks when the service is enabled."
  type        = number
  default     = 1

  validation {
    condition     = var.ecs_desired_count >= 1
    error_message = "ecs_desired_count must be at least one."
  }
}

variable "create_ecs_service" {
  description = "Whether to create the backend task definition and ECS service."
  type        = bool
  default     = false
}

variable "backend_image_tag" {
  description = "Backend ECR image tag. Use an immutable commit SHA tag when enabling ECS."
  type        = string
  default     = "latest"

  validation {
    condition     = trimspace(var.backend_image_tag) != ""
    error_message = "backend_image_tag must not be empty."
  }
}

variable "cloudwatch_log_retention" {
  description = "Backend CloudWatch log retention in days."
  type        = number
  default     = 7

  validation {
    condition     = var.cloudwatch_log_retention > 0
    error_message = "cloudwatch_log_retention must be greater than zero."
  }
}

variable "cors_allowed_origins" {
  description = "Frontend origins passed to the backend CORS configuration. Configure the CloudFront origin later."
  type        = list(string)
  default     = ["http://localhost:4200"]

  validation {
    condition     = length(var.cors_allowed_origins) > 0 && alltrue([for origin in var.cors_allowed_origins : trimspace(origin) != "" && origin != "*"])
    error_message = "cors_allowed_origins must contain at least one non-wildcard origin."
  }
}

variable "db_name" {
  description = "Initial MySQL database name."
  type        = string
  default     = "skill_matrix_db"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,63}$", var.db_name))
    error_message = "db_name must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "db_username" {
  description = "RDS master/application username."
  type        = string
  default     = "skillmatrixadmin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,15}$", var.db_username)) && lower(var.db_username) != "root"
    error_message = "db_username must be 1-16 alphanumeric/underscore characters, start with a letter, and not be root."
  }
}

variable "mysql_engine_version" {
  description = "RDS MySQL 8 engine version or supported major version."
  type        = string
  default     = "8.0"
}

variable "rds_instance_class" {
  description = "RDS instance class for the Demo database."
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "Initial RDS storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.rds_allocated_storage >= 20
    error_message = "rds_allocated_storage must be at least 20 GiB."
  }
}

variable "rds_max_allocated_storage" {
  description = "Maximum autoscaled RDS storage in GiB."
  type        = number
  default     = 50

  validation {
    condition     = var.rds_max_allocated_storage >= var.rds_allocated_storage
    error_message = "rds_max_allocated_storage must be at least rds_allocated_storage."
  }
}

variable "rds_backup_retention" {
  description = "RDS automated backup retention in days."
  type        = number
  default     = 7

  validation {
    condition     = var.rds_backup_retention >= 0 && var.rds_backup_retention <= 35
    error_message = "rds_backup_retention must be between 0 and 35 days."
  }
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final RDS snapshot when destroying Demo."
  type        = bool
  default     = true
}

variable "ecr_image_retention_count" {
  description = "Number of tagged backend images retained in ECR."
  type        = number
  default     = 10

  validation {
    condition     = var.ecr_image_retention_count > 0
    error_message = "ecr_image_retention_count must be greater than zero."
  }
}

variable "cloudfront_price_class" {
  description = "CloudFront price class for the Demo distribution."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "enable_ipv6" {
  description = "Whether CloudFront accepts IPv6 viewer requests."
  type        = bool
  default     = true
}

variable "github_org" {
  description = "GitHub organization or owner for the Demo repository."
  type        = string
  default     = "VenkataJanga"
}

variable "github_repo" {
  description = "GitHub repository used by Demo CI/CD."
  type        = string
  default     = "skill-matrix-platform"
}

variable "github_branch" {
  description = "GitHub branch used by Demo workflow triggers."
  type        = string
  default     = "Demo"
}

variable "github_environment" {
  description = "GitHub Environment used by trusted Demo deployment jobs."
  type        = string
  default     = "demo"
}

variable "create_github_oidc_provider" {
  description = "Whether to create the GitHub Actions OIDC provider. Set false if it already exists in the account."
  type        = bool
  default     = true
}

variable "existing_github_oidc_provider_arn" {
  description = "Existing GitHub Actions OIDC provider ARN when provider creation is disabled."
  type        = string
  default     = null
}

variable "terraform_state_bucket_name" {
  description = "Bootstrapped Terraform state bucket name used to scope the GitHub Terraform role."
  type        = string
  default     = ""
}

variable "alert_emails" {
  description = "Optional email recipients for CloudWatch alarm SNS notifications."
  type        = list(string)
  default     = []
}

variable "ecs_cpu_alarm_threshold" {
  description = "ECS CPU alarm threshold as a percentage."
  type        = number
  default     = 80
}

variable "ecs_memory_alarm_threshold" {
  description = "ECS memory alarm threshold as a percentage."
  type        = number
  default     = 80
}

variable "rds_cpu_alarm_threshold" {
  description = "RDS CPU alarm threshold as a percentage."
  type        = number
  default     = 80
}

variable "rds_free_storage_alarm_bytes" {
  description = "RDS free storage alarm threshold in bytes."
  type        = number
  default     = 3221225472
}

variable "monthly_budget_usd" {
  description = "Monthly AWS cost budget limit in USD."
  type        = number
  default     = 90
}

variable "budget_notification_emails" {
  description = "Optional email recipients for actual-cost budget notifications."
  type        = list(string)
  default     = []
}

variable "cloudtrail_log_retention_days" {
  description = "CloudTrail S3 log retention in days for Demo."
  type        = number
  default     = 90
}
