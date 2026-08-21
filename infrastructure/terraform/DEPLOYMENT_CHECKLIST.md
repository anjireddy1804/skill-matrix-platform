# Skill Matrix Demo Deployment Checklist

> **DEMO ENVIRONMENT — DUMMY / NON-CONFIDENTIAL DATA ONLY**

Use dummy data only. Never use real employee information, client-sensitive information, production database dumps, production credentials, or sensitive personal information.

## Local prerequisites

- [ ] Git installed
- [ ] Terraform 1.10 or later installed
- [ ] AWS CLI installed and authenticated through an approved profile/role
- [ ] Docker Desktop with the Linux engine running
- [ ] Java 21 installed
- [ ] Maven installed
- [ ] Node 20 available when building the frontend

## AWS account

- [ ] Confirm the intended AWS account and `ap-south-1` region
- [ ] Confirm MFA and least-privilege access
- [ ] Confirm billing visibility
- [ ] Confirm this is a Demo account or Demo-only resource scope

## Terraform bootstrap

- [ ] Configure AWS credentials using the AWS credential chain
- [ ] Review `bootstrap/terraform.tfvars.example`
- [ ] Run bootstrap `terraform init`, `terraform fmt`, `terraform validate`, and `terraform plan`
- [ ] Review and manually approve bootstrap apply
- [ ] Capture the `state_bucket_name` output
- [ ] Create local `environments/demo/backend.hcl` from the example
- [ ] Confirm `backend.hcl` remains ignored by Git

## Demo infrastructure

- [ ] Copy `environments/demo/terraform.tfvars.example` to local `terraform.tfvars`
- [ ] Set the state bucket name
- [ ] Review region, CIDRs, RDS sizing, budget, alarm thresholds, and email lists
- [ ] Keep `create_ecs_service = false` for the first infrastructure deployment
- [ ] Run `terraform init -backend-config=backend.hcl`
- [ ] Run `terraform fmt -recursive`
- [ ] Run `terraform validate`
- [ ] Run `terraform plan`
- [ ] Review expected resources and cost
- [ ] Manually approve apply

## GitHub setup

- [ ] Create and push the `Demo` branch manually
- [ ] Create protected GitHub Environment `demo`
- [ ] Configure role ARNs and output-derived variables in that Environment
- [ ] Configure `TF_STATE_BUCKET`, `AWS_REGION`, ECR, ECS, frontend, and CloudFront variables
- [ ] Configure `CORS_ALLOWED_ORIGINS_JSON` with the CloudFront application URL before enabling ECS
- [ ] Configure `CREATE_ECS_SERVICE=false` initially
- [ ] Do not configure `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY`
- [ ] Confirm the OIDC trust subject matches `repo:VenkataJanga/skill-matrix-platform:environment:demo`

## First backend deployment

- [ ] Run `mvn clean verify` locally
- [ ] Build the backend image using `backend/Dockerfile`
- [ ] Authenticate to ECR through an approved AWS identity
- [ ] Push the first image using the Git commit SHA as the tag
- [ ] Set `BACKEND_IMAGE_TAG` to that SHA
- [ ] Set `CREATE_ECS_SERVICE=true`
- [ ] Run Terraform plan and manually approve apply
- [ ] Confirm ECS task placement and service health
- [ ] Confirm Flyway connects to RDS and applies `classpath:db/migration`
- [ ] Confirm ALB target health at `/actuator/health`

## Frontend

- [ ] Run `npm ci` in `frontend`
- [ ] Run `npm run build`
- [ ] Confirm deployable files are in `frontend/dist/skill-matrix-ui/browser`
- [ ] Run the frontend workflow or sync that exact directory to the Terraform-created bucket
- [ ] Invalidate CloudFront after a successful upload
- [ ] Open the `application_url` output

## Validation

- [ ] Login works
- [ ] RBAC works for Admin, Lead Manager, and Technician
- [ ] Admin User Management works
- [ ] Technician Assignment works
- [ ] Main navigation and direct route refresh work
- [ ] `/actuator/health` is healthy through the ALB
- [ ] ECS logs appear in CloudWatch
- [ ] SNS alarm subscription is confirmed if configured
- [ ] Budget notifications are configured if configured
- [ ] CloudTrail is logging management events

## Cost shutdown

- [ ] Set `ecs_desired_count = 0` when the application is idle
- [ ] Stop RDS temporarily when appropriate, knowing AWS automatically restarts it after the supported stop period
- [ ] Remember that the provisioned ALB continues to incur charges
- [ ] Review ECR, CloudWatch, CloudTrail, S3, and CloudFront usage

## Destroy

- [ ] Destroy is manual only and never part of normal workflows
- [ ] Review the RDS final-snapshot setting
- [ ] Empty versioned frontend and CloudTrail buckets if Terraform cannot remove them
- [ ] Review CloudTrail retention and state before destructive actions
- [ ] Confirm budget and alarm recipients before teardown
