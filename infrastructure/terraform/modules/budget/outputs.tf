output "budget_name" {
  description = "Monthly AWS budget name."
  value       = aws_budgets_budget.monthly.name
}

output "budget_id" {
  description = "Monthly AWS budget resource ID."
  value       = aws_budgets_budget.monthly.id
}
