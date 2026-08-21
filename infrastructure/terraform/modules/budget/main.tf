locals {
  budget_name = "${var.project_name}-${var.environment}-monthly"
}

resource "aws_budgets_budget" "monthly" {
  name         = local.budget_name
  budget_type  = "COST"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "notification" {
    for_each = length(var.budget_notification_emails) == 0 ? [] : [50, 80, 100]

    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = var.budget_notification_emails
    }
  }

  tags = merge(var.common_tags, {
    Name = local.budget_name
  })
}
