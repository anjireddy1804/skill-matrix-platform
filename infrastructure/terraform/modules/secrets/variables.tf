variable "project_name" {
  description = "Project name used in the secret name and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in the secret name and tags."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to the secret container."
  type        = map(string)
  default     = {}
}
