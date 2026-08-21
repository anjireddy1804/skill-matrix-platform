variable "project_name" {
  description = "Project name used in alarm and SNS names."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in alarm and SNS names."
  type        = string
}

variable "alb_arn" {
  description = "Existing ALB ARN used to derive CloudWatch dimensions."
  type        = string
}

variable "target_group_arn" {
  description = "Existing target group ARN used to derive CloudWatch dimensions."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name for ECS service alarms."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name for ECS service alarms."
  type        = string
}

variable "create_ecs_service" {
  description = "Whether the ECS service and service-specific alarms exist."
  type        = bool
  default     = false
}

variable "rds_identifier" {
  description = "RDS instance identifier for database alarms."
  type        = string
}

variable "alert_emails" {
  description = "Optional email recipients for SNS alarm notifications."
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

variable "common_tags" {
  description = "Common tags applied to observability resources."
  type        = map(string)
  default     = {}
}
