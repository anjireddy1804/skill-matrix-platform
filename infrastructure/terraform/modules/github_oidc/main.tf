data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "github_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:environment:${var.github_environment}"]
    }
  }
}

locals {
  name_prefix       = "${var.project_name}-${var.environment}"
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : var.oidc_provider_arn
  ecs_cluster_name  = "${local.name_prefix}-cluster"
  ecs_service_name  = "${local.name_prefix}-backend"
  ecs_service_arn   = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${local.ecs_cluster_name}/${local.ecs_service_name}"
  ecs_cluster_arn   = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${local.ecs_cluster_name}"
  ecs_task_arn      = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:task/${local.ecs_cluster_name}/*"
  task_family_arn   = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:task-definition/${local.ecs_service_name}:*"
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = merge(var.common_tags, {
    Name = "github-actions-oidc"
  })
}

data "aws_iam_policy_document" "terraform_permissions" {
  statement {
    sid    = "TerraformManagedServices"
    effect = "Allow"
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "ecs:*",
      "ecr:*",
      "rds:*",
      "secretsmanager:*",
      "logs:*",
      "cloudfront:*",
      "s3:GetBucket*",
      "s3:GetObject*",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:PutBucket*",
      "s3:PutObject*",
      "s3:DeleteObject*",
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:PassRole",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.terraform_state_bucket_name == "" ? [] : [var.terraform_state_bucket_name]

    content {
      sid    = "TerraformStateBucket"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      resources = [
        "arn:aws:s3:::${statement.value}",
        "arn:aws:s3:::${statement.value}/*"
      ]
    }
  }
}

resource "aws_iam_role" "terraform" {
  name               = "${local.name_prefix}-github-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-github-terraform-role"
  })
}

resource "aws_iam_role_policy" "terraform" {
  name   = "terraform-demo-infrastructure"
  role   = aws_iam_role.terraform.id
  policy = data.aws_iam_policy_document.terraform_permissions.json
}

data "aws_iam_policy_document" "application_permissions" {
  statement {
    sid    = "EcrPush"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EcrRepositoryPush"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.ecr_repository_arn]
  }

  statement {
    sid    = "EcsReadAndUpdate"
    effect = "Allow"
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks"
    ]
    resources = [
      local.ecs_cluster_arn,
      local.ecs_service_arn,
      local.ecs_task_arn,
      local.task_family_arn
    ]
  }

  statement {
    sid       = "RegisterTaskDefinition"
    effect    = "Allow"
    actions   = ["ecs:RegisterTaskDefinition"]
    resources = ["*"]
  }

  statement {
    sid       = "UpdateEcsService"
    effect    = "Allow"
    actions   = ["ecs:UpdateService"]
    resources = [local.ecs_service_arn]
  }

  statement {
    sid       = "PassOnlyEcsRoles"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [var.ecs_execution_role_arn, var.ecs_task_role_arn]
  }

  statement {
    sid    = "FrontendBucketDeployment"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      var.frontend_bucket_arn,
      "${var.frontend_bucket_arn}/*"
    ]
  }

  statement {
    sid       = "CloudFrontInvalidation"
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [var.cloudfront_distribution_arn]
  }
}

resource "aws_iam_role" "application" {
  name               = "${local.name_prefix}-github-application-role"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-github-application-role"
  })
}

resource "aws_iam_role_policy" "application" {
  name   = "application-demo-deployment"
  role   = aws_iam_role.application.id
  policy = data.aws_iam_policy_document.application_permissions.json
}
