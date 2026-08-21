output "alb_arn" {
  description = "Application Load Balancer ARN."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "Backend target group ARN."
  value       = aws_lb_target_group.backend.arn
}

output "listener_arn" {
  description = "HTTP listener ARN."
  value       = aws_lb_listener.http.arn
}
