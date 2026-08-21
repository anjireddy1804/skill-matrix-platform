output "bucket_name" {
  description = "Private S3 bucket name for Angular build artifacts."
  value       = aws_s3_bucket.frontend.bucket
}

output "bucket_arn" {
  description = "Private S3 bucket ARN for Angular build artifacts."
  value       = aws_s3_bucket.frontend.arn
}

output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "CloudFront distribution domain name."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "application_url" {
  description = "Public application URL using the default CloudFront certificate."
  value       = "https://${aws_cloudfront_distribution.this.domain_name}"
}
