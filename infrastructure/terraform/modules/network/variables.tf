variable "project_name" {
  description = "Project name used in resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in resource names and tags."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets, one per availability zone."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets, one per availability zone."
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDRs are required."
  }
}

variable "availability_zones" {
  description = "Exactly two availability zones selected by the environment configuration."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Exactly two distinct availability zones are required."
  }
}

variable "common_tags" {
  description = "Common tags applied to network resources."
  type        = map(string)
  default     = {}
}
