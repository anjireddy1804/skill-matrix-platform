locals {
  name_prefix       = "${var.project_name}-${var.environment}"
  db_subnet_group   = "${local.name_prefix}-db-subnet-group"
  instance_identifier = "${local.name_prefix}-mysql"
}

resource "aws_db_subnet_group" "this" {
  name       = local.db_subnet_group
  subnet_ids = var.db_subnet_ids

  tags = merge(var.common_tags, {
    Name = local.db_subnet_group
  })
}

resource "aws_db_instance" "this" {
  identifier                  = local.instance_identifier
  engine                      = "mysql"
  engine_version              = var.mysql_engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  max_allocated_storage       = var.max_allocated_storage
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  port                        = 3306

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = var.backup_retention_period
  backup_window           = "19:00-19:30"
  maintenance_window      = "sun:20:00-sun:20:30"
  auto_minor_version_upgrade = true
  apply_immediately          = false

  performance_insights_enabled = false
  monitoring_interval          = 0
  deletion_protection          = false
  skip_final_snapshot          = var.skip_final_snapshot
  copy_tags_to_snapshot        = true

  tags = merge(var.common_tags, {
    Name = local.instance_identifier
  })
}
