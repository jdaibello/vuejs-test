resource "aws_ecs_task_definition" "backend_task_definition" {
  cpu = 256
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_role.arn
  family = "ecs-cluster-task-definition-backend"
  network_mode = "awsvpc"
  requires_compatibilities = var.launch_type

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "backend",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.application_name}-backend:${var.ecr_latest_tag}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.ecs_awslogs_group.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${aws_cloudwatch_log_group.ecs_awslogs_group.name}-backend"
      }
    },
    "environment": [
      {
        "name": "DB_HOST",
        "valueFrom": "${var.db_host}"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "${var.db_password}"
      },
      {
        "name": "DB_PORT",
        "valueFrom": "${var.db_port}"
      },
      {
        "name": "DB_USER",
        "valueFrom": "${var.db_user}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    cpu_architecture         = "X86_64"
    operating_system_family  = "LINUX"
  }
}
