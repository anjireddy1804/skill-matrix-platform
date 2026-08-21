# Skill Matrix Demo Cost Guide

> **DEMO ENVIRONMENT — DUMMY / NON-CONFIDENTIAL DATA ONLY**

The Demo planning range is approximately **$15-$90/month**, but actual cost can exceed that range. The result depends on Free Tier eligibility, region, uptime, traffic, data transfer, RDS/ECS runtime, ALB uptime, log volume, and storage.

## Main cost drivers

1. **Application Load Balancer**: continues to incur charges while provisioned, even when ECS has no running tasks.
2. **RDS MySQL**: instance uptime, storage, backups, and data transfer. RDS is normally the largest always-on component.
3. **ECS Fargate**: task CPU and memory charges while the service runs. Demo defaults to one task.
4. **CloudWatch Logs**: ingestion and storage based on application volume; backend logs retain seven days.
5. **CloudFront and S3**: generally smaller for low-traffic Demo use, but depend on requests, transfer, and storage.
6. **ECR**: image storage; lifecycle rules retain approximately 10 tagged images and remove untagged images after one day.
7. **Secrets Manager, CloudTrail, and SNS**: secret containers, CloudTrail storage, notifications, and usage contribute smaller variable charges.
8. **AWS Budgets**: budget configuration itself may have account-specific pricing; notifications are configured only when recipients are supplied.

ALB plus always-running RDS and ECS place the environment toward the upper part of the planning range. No exact monthly price is guaranteed.

## Cost-saving operations

- Set `ecs_desired_count = 0` when the application is not needed. Do not destroy the ECS service solely to pause compute.
- RDS can be manually stopped temporarily, but AWS automatically restarts a stopped DB after the maximum supported stop duration. It cannot remain stopped indefinitely.
- ALB charges continue while the ALB is provisioned.
- CloudFront and S3 are usually modest for low-traffic Demo use.
- Demo avoids NAT Gateway, Multi-AZ RDS, read replicas, Container Insights, dashboards, and long log retention.

No automatic schedules are created in this project.
