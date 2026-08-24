module "network" {
  source = "../../modules/network"

  project_name            = var.project_name
  environment             = var.environment
  vpc_cidr                = var.vpc_cidr
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_db_subnet_cidrs = var.private_db_subnet_cidrs
  availability_zones      = local.availability_zones
  common_tags             = local.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  application_port = var.container_port
  common_tags      = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name          = var.project_name
  environment           = var.environment
  image_retention_count = var.ecr_image_retention_count
  common_tags           = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  project_name            = var.project_name
  environment             = var.environment
  db_name                 = var.db_name
  db_username             = var.db_username
  mysql_engine_version    = var.mysql_engine_version
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  max_allocated_storage   = var.rds_max_allocated_storage
  backup_retention_period = var.rds_backup_retention
  skip_final_snapshot     = var.rds_skip_final_snapshot
  db_subnet_ids           = module.network.private_db_subnet_ids
  security_group_id       = module.security.rds_security_group_id
  common_tags             = local.common_tags
}

module "secrets" {
  source = "../../modules/secrets"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  target_port       = var.container_port
  health_check_path = var.health_check_path
  common_tags       = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name             = var.project_name
  environment              = var.environment
  aws_region               = var.aws_region
  public_subnet_ids        = module.network.public_subnet_ids
  security_group_id        = module.security.ecs_security_group_id
  target_group_arn         = module.alb.target_group_arn
  ecr_repository_url       = module.ecr.repository_url
  backend_image_tag        = var.backend_image_tag
  create_ecs_service       = var.create_ecs_service
  container_port           = var.container_port
  ecs_cpu                  = var.ecs_cpu
  ecs_memory               = var.ecs_memory
  ecs_desired_count        = var.ecs_desired_count
  cloudwatch_log_retention = var.cloudwatch_log_retention
  database_endpoint        = module.rds.endpoint
  database_port            = module.rds.port
  database_name            = module.rds.database_name
  database_username        = module.rds.username
  rds_master_secret_arn    = module.rds.master_secret_arn
  jwt_secret_arn           = module.secrets.jwt_secret_arn
  cors_allowed_origins     = var.cors_allowed_origins
  common_tags              = local.common_tags
}

module "frontend" {
  source = "../../modules/frontend"

  project_name           = var.project_name
  environment            = var.environment
  alb_dns_name           = module.alb.alb_dns_name
  cloudfront_price_class = var.cloudfront_price_class
  enable_ipv6            = var.enable_ipv6
  common_tags            = local.common_tags
}

module "github_oidc" {
  source = "../../modules/github_oidc"

  project_name                = var.project_name
  environment                 = var.environment
  github_org                  = var.github_org
  github_repo                 = var.github_repo
  github_environment          = var.github_environment
  aws_region                  = var.aws_region
  create_oidc_provider        = var.create_github_oidc_provider
  oidc_provider_arn           = var.existing_github_oidc_provider_arn
  terraform_state_bucket_name = var.terraform_state_bucket_name
  ecr_repository_arn          = module.ecr.repository_arn
  frontend_bucket_arn         = module.frontend.bucket_arn
  cloudfront_distribution_arn = module.frontend.distribution_arn
  ecs_execution_role_arn      = module.ecs.execution_role_arn
  ecs_task_role_arn           = module.ecs.task_role_arn
  common_tags                 = local.common_tags
}

module "observability" {
  source = "../../modules/observability"

  project_name                 = var.project_name
  environment                  = var.environment
  alb_arn                      = module.alb.alb_arn
  target_group_arn             = module.alb.target_group_arn
  ecs_cluster_name             = module.ecs.cluster_name
  ecs_service_name             = "${var.project_name}-${var.environment}-backend"
  create_ecs_service           = var.create_ecs_service
  rds_identifier               = "${var.project_name}-${var.environment}-mysql"
  alert_emails                 = var.alert_emails
  ecs_cpu_alarm_threshold      = var.ecs_cpu_alarm_threshold
  ecs_memory_alarm_threshold   = var.ecs_memory_alarm_threshold
  rds_cpu_alarm_threshold      = var.rds_cpu_alarm_threshold
  rds_free_storage_alarm_bytes = var.rds_free_storage_alarm_bytes
  common_tags                  = local.common_tags
}

module "budget" {
  source = "../../modules/budget"

  project_name               = var.project_name
  environment                = var.environment
  monthly_budget_usd         = var.monthly_budget_usd
  budget_notification_emails = var.budget_notification_emails
  common_tags                = local.common_tags
}

module "audit" {
  source = "../../modules/audit"

  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = var.cloudtrail_log_retention_days
  common_tags        = local.common_tags
}
