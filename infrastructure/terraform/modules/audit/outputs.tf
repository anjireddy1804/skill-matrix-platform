output "trail_arn" {
  description = "CloudTrail management trail ARN."
  value       = aws_cloudtrail.this.arn
}

output "trail_name" {
  description = "CloudTrail management trail name."
  value       = aws_cloudtrail.this.name
}

output "log_bucket_name" {
  description = "Private S3 bucket storing CloudTrail logs."
  value       = aws_s3_bucket.cloudtrail.bucket
}

output "log_bucket_arn" {
  description = "ARN of the private CloudTrail log bucket."
  value       = aws_s3_bucket.cloudtrail.arn
}
