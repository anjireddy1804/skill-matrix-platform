locals {
  name_prefix   = "${var.project_name}-${var.environment}"
  load_balancer = "${local.name_prefix}-alb"
  target_group  = "${local.name_prefix}-backend-tg"
}

resource "aws_lb" "this" {
  name               = local.load_balancer
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  drop_invalid_header_fields = true

  tags = merge(var.common_tags, {
    Name = local.load_balancer
  })
}

resource "aws_lb_target_group" "backend" {
  name        = local.target_group
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(var.common_tags, {
    Name = local.target_group
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-http-listener"
  })
}
