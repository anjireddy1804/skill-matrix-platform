variable "project_name" {
  description = "Project name used in frontend resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in frontend resource names and tags."
  type        = string
}

variable "alb_dns_name" {
  description = "Existing ALB DNS name used as the CloudFront API origin."
  type        = string
}

variable "cloudfront_price_class" {
  description = "CloudFront price class for the Demo distribution."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "enable_ipv6" {
  description = "Whether CloudFront accepts IPv6 viewer requests."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to frontend resources."
  type        = map(string)
  default     = {}
}
