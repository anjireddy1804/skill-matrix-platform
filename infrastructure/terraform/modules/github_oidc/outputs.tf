output "oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = local.oidc_provider_arn
}

output "terraform_role_arn" {
  description = "GitHub Actions role for controlled Demo Terraform operations."
  value       = aws_iam_role.terraform.arn
}

output "application_role_arn" {
  description = "GitHub Actions role for backend and frontend deployments."
  value       = aws_iam_role.application.arn
}
