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
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.application_name}-backend:${data.aws_ssm_parameter.backend_latest_tag.value}",
    "secrets": [
      {
        "name": "DB_HOST",
        "valueFrom": "${var.ssm_parameter_common_arn}/backend/DB_HOST"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "${var.ssm_parameter_common_arn}/backend/DB_PASSWORD"
      },
      {
        "name": "DB_PORT",
        "valueFrom": "${var.ssm_parameter_common_arn}/backend/DB_PORT"
      },
      {
        "name": "DB_USER",
        "valueFrom": "${var.ssm_parameter_common_arn}/backend/DB_USER"
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
