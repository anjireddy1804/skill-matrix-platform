output "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_region" {
  description = "AWS region containing the Terraform state bucket."
  value       = data.aws_region.current.name
}
