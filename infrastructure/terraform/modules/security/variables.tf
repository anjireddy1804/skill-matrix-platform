variable "project_name" {
  description = "Project name used in security group names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in security group names and tags."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the security groups are created."
  type        = string
}

variable "application_port" {
  description = "Backend application port reachable from the ALB security group."
  type        = number
  default     = 8080
}

variable "common_tags" {
  description = "Common tags applied to security group resources."
  type        = map(string)
  default     = {}
}
