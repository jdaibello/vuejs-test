resource "aws_cloudwatch_log_group" "ecs_awslogs_group" {
  name = var.awslogs_group
  retention_in_days = var.log_group_retention_id_days

  tags = {
    Project = "Backend"
  }
}
