locals {
  secret_name = "${var.project_name}/${var.environment}/app-jwt-secret"
}

resource "random_password" "jwt" {
  length           = 64
  special          = false
  override_special = ""
}

resource "aws_secretsmanager_secret" "jwt" {
  name                    = local.secret_name
  description             = "JWT signing secret for the Skill Matrix application."
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = local.secret_name
  })
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id     = aws_secretsmanager_secret.jwt.id
  secret_string = random_password.jwt.result
}
