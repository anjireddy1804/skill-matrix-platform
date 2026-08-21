locals {
  name_prefix      = "${var.project_name}-${var.environment}"
  cluster_name     = "${local.name_prefix}-cluster"
  service_name     = "${local.name_prefix}-backend"
  task_family      = "${local.name_prefix}-backend"
  log_group_name   = "/ecs/${local.name_prefix}-backend"
  container_name   = "backend"
  image            = "${var.ecr_repository_url}:${var.backend_image_tag}"
  database_url     = "jdbc:mysql://${var.database_endpoint}:${var.database_port}/${var.database_name}"
}

resource "aws_ecs_cluster" "this" {
  name = local.cluster_name

  tags = merge(var.common_tags, {
    Name = local.cluster_name
  })
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = local.log_group_name
  retention_in_days = var.cloudwatch_log_retention

  tags = merge(var.common_tags, {
    Name = local.log_group_name
  })
}

data "aws_iam_policy_document" "task_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.name_prefix}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "execution_managed" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "execution_secrets" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      var.rds_master_secret_arn,
      var.jwt_secret_arn
    ]
  }
}

resource "aws_iam_role_policy" "execution_secrets" {
  name   = "read-application-secrets"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.execution_secrets.json
}

resource "aws_iam_role" "task" {
  name               = "${local.name_prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-task-role"
  })
}

resource "aws_ecs_task_definition" "backend" {
  count = var.create_ecs_service ? 1 : 0

  family                   = local.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = local.image
      essential = true
      portMappings = [
        {
          name          = "backend-http"
          containerPort  = var.container_port
          hostPort       = var.container_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "prod"
        },
        {
          name  = "SPRING_DATASOURCE_URL"
          value = local.database_url
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = var.database_username
        },
        {
          name  = "APP_CORS_ALLOWED_ORIGINS"
          value = join(",", var.cors_allowed_origins)
        }
      ]
      secrets = [
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = "${var.rds_master_secret_arn}:password::"
        },
        {
          name      = "APP_JWT_SECRET"
          valueFrom = var.jwt_secret_arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "backend"
        }
      }
    }
  ])

  lifecycle {
    precondition {
      condition     = var.backend_image_tag != "latest"
      error_message = "Set backend_image_tag to an explicit immutable tag before enabling the ECS service."
    }
  }

  tags = merge(var.common_tags, {
    Name = local.task_family
  })
}

resource "aws_ecs_service" "backend" {
  count = var.create_ecs_service ? 1 : 0

  name            = local.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend[0].arn
  desired_count   = var.ecs_desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  enable_ecs_managed_tags             = true
  propagate_tags                      = "SERVICE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  lifecycle {
    # Future CI/CD owns task-definition revisions and ECS service rollouts.
    ignore_changes = [task_definition]
  }

  tags = merge(var.common_tags, {
    Name = local.service_name
  })
}
