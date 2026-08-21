variable "project_name" {
  description = "Project name used in ALB resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in ALB resource names and tags."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ALB target group is created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least two public subnet IDs are required for the ALB."
  }
}

variable "security_group_id" {
  description = "Existing ALB security group ID."
  type        = string
}

variable "target_port" {
  description = "Backend port used by the target group."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "HTTP path used by the ALB target health check."
  type        = string
  default     = "/actuator/health"
}

variable "common_tags" {
  description = "Common tags applied to ALB resources."
  type        = map(string)
  default     = {}
}
