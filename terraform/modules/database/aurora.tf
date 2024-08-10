resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier        = "joaodaibellotestauroracluster"
  database_name             = "backendb"
  engine                    = "aurora-postgresql"
  engine_mode               = "provisioned"
  final_snapshot_identifier = "joaodaibellotestauroraclusterfinalsnapshot-${random_uuid.final_snapshot_uuid_suffix.result}"
  enable_http_endpoint      = true
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.rds_kms_key.arn

  timeouts {
    create = "15m"
  }

  serverlessv2_scaling_configuration {
    max_capacity = 1.5
    min_capacity = 1
  }

  master_username                 = var.db_username
  master_password                 = var.db_password
  vpc_security_group_ids          = [aws_security_group.databse_security_group.id]
  db_subnet_group_name            = aws_db_subnet_group.database_subnet_group.name
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Project = "Backend"
  }
}

resource "aws_rds_cluster_instance" "aurora_serverless_instance" {
  identifier         = "joaodaibellotestauroraclusterinstance"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version

  timeouts {
    create = "15m"
  }

  tags = {
    Project = "Backend"
  }
}

# resource "aws_rds_cluster_activity_stream" "aurora_activity_stream" {
#   resource_arn                        = aws_rds_cluster.aurora_cluster.arn
#   kms_key_id                          = aws_kms_key.rds_kms_key.arn
#   mode                                = "async"

#   depends_on = [aws_rds_cluster_instance.aurora_serverless_instance]
# }

# Random UUID

resource "random_uuid" "final_snapshot_uuid_suffix" {}
