# Skill Matrix Demo Operations Runbook

> **DEMO ENVIRONMENT — DUMMY / NON-CONFIDENTIAL DATA ONLY**

## Application URL

Read the `application_url` Terraform output. The public entry point is the CloudFront domain, not the ALB DNS name.

## ECS and logs

Use the `ecs_cluster_name`, `ecs_service_name`, and `ecs_task_definition_family` outputs with the AWS ECS console or CLI. Backend logs are in the `backend_log_group_name` output, normally `/ecs/skill-matrix-demo-backend`.

Check service events, task stopped reasons, image pull errors, and task health before restarting anything.

## ALB target health

Inspect the `target_group_arn` target health. The target group checks `/actuator/health` on port 8080 and expects HTTP 200. An unhealthy target usually means the task is not running, the container is not listening on 8080, startup is still in progress, or the ECS security group path is incorrect.

## RDS connectivity

Check the RDS endpoint, private DB subnet placement, RDS security group ingress from ECS only, and the ECS `SPRING_DATASOURCE_URL`. Never make RDS public to troubleshoot. Confirm the RDS-managed secret contains the expected password field and that ECS execution-role access is present.

## Flyway startup failure

Review ECS logs for JDBC connectivity, authentication, schema validation, and migration checksum errors. Confirm `SPRING_PROFILES_ACTIVE=prod`, the RDS endpoint, database name, and the `classpath:db/migration` location. Do not edit an applied migration; create a reviewed new migration instead.

## Backend rollback

Use the previous immutable ECR image/task-definition revision. Update the ECS service through a reviewed deployment action or manual ECS operation, then wait for service stability. Do not overwrite immutable SHA tags.

## Frontend rollback

Restore the previous known-good Angular artifact set to the private frontend bucket and invalidate CloudFront for `/*`. Keep the ALB API origin unchanged.

## Scaling and pausing Demo

Set `ecs_desired_count = 0` through a reviewed Terraform change when the application is idle. RDS may be stopped temporarily, but AWS automatically restarts a stopped instance after the supported maximum stop duration. The ALB continues to cost while provisioned.

## CloudFront invalidation

After a successful S3 artifact upload, invalidate `/*` on the distribution identified by `cloudfront_distribution_id`. Do not invalidate before the upload succeeds.

## Alarms and budget

- Unhealthy targets: inspect ECS task events and `/actuator/health` first.
- ALB 5xx: inspect ALB access behavior and backend logs.
- ECS CPU/memory: inspect only when `create_ecs_service = true`; adjust sizing deliberately.
- RDS CPU/free storage: inspect queries, connections, storage, and migration activity.
- Budget: review current spend and identify ALB/RDS/ECS uptime, transfer, and logs before changing thresholds.

SNS email subscriptions and budget email notifications remain inactive until recipients confirm AWS subscription emails.
