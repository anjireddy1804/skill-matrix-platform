variable "project_name" {
  description = "Project name used in the budget name and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in the budget name and tags."
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly AWS cost budget limit in USD."
  type        = number
  default     = 90

  validation {
    condition     = var.monthly_budget_usd > 0
    error_message = "monthly_budget_usd must be greater than zero."
  }
}

variable "budget_notification_emails" {
  description = "Optional email recipients for actual-cost budget notifications."
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags applied to budget resources."
  type        = map(string)
  default     = {}
}
