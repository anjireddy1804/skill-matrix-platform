variable "project_name" {
  description = "Project name used in RDS resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in RDS resource names and tags."
  type        = string
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
  description = "RDS master username managed through the RDS Secrets Manager integration."
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

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial RDS storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage must be at least 20 GiB."
  }
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled RDS storage in GiB."
  type        = number
  default     = 50

  validation {
    condition     = var.max_allocated_storage >= var.allocated_storage
    error_message = "max_allocated_storage must be greater than or equal to allocated_storage."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 0 and 35 days."
  }
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the Demo database."
  type        = bool
  default     = true
}

variable "db_subnet_ids" {
  description = "Private subnet IDs for the RDS DB subnet group."
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_ids) >= 2
    error_message = "At least two private DB subnet IDs are required."
  }
}

variable "security_group_id" {
  description = "Security group ID allowed to connect to MySQL."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to RDS resources."
  type        = map(string)
  default     = {}
}
