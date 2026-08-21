variable "project_name" {
  description = "Project name used in the ECR repository name and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in the ECR repository name and tags."
  type        = string
}

variable "image_retention_count" {
  description = "Number of tagged images to retain."
  type        = number
  default     = 10

  validation {
    condition     = var.image_retention_count > 0
    error_message = "image_retention_count must be greater than zero."
  }
}

variable "common_tags" {
  description = "Common tags applied to ECR resources."
  type        = map(string)
  default     = {}
}
