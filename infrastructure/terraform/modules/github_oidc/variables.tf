variable "project_name" {
  description = "Project name used in IAM role names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in IAM role names and tags."
  type        = string
}

variable "github_org" {
  description = "GitHub organization or owner allowed to assume the deployment roles."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the deployment roles."
  type        = string
}

variable "github_environment" {
  description = "GitHub Environment used by trusted deployment jobs."
  type        = string
  default     = "demo"
}

variable "aws_region" {
  description = "AWS region used to construct scoped deployment resource ARNs."
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether this module should create the GitHub Actions OIDC provider. Set false when it already exists."
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "Existing GitHub Actions OIDC provider ARN when create_oidc_provider is false."
  type        = string
  default     = null
}

variable "terraform_state_bucket_name" {
  description = "Existing Terraform state bucket name used to scope Terraform role state access."
  type        = string
  default     = ""
}

variable "ecr_repository_arn" {
  description = "Backend ECR repository ARN for application deployment permissions."
  type        = string
}

variable "frontend_bucket_arn" {
  description = "Frontend S3 bucket ARN for application deployment permissions."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN for frontend invalidation permissions."
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "ECS execution role ARN allowed for application deployment PassRole."
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECS application task role ARN allowed for application deployment PassRole."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
