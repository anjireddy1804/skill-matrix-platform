variable "project_name" {
  description = "Project name used in the state bucket name and tags."
  type        = string
  default     = "skill-matrix"
}

variable "environment" {
  description = "Environment associated with the bootstrap resources."
  type        = string
  default     = "demo"
}

variable "aws_region" {
  description = "AWS region where the Terraform state bucket is created."
  type        = string
  default     = "ap-south-1"
}
