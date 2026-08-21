variable "project_name" {
  description = "Project name used in CloudTrail resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in CloudTrail resource names and tags."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudTrail objects in the audit bucket."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days > 0
    error_message = "log_retention_days must be greater than zero."
  }
}

variable "common_tags" {
  description = "Common tags applied to CloudTrail resources."
  type        = map(string)
  default     = {}
}
