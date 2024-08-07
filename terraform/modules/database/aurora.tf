resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier        = "joaodaibellotestauroracluster"
  database_name             = "backendb"
  engine                    = "aurora-postgresql"
  engine_mode               = "provisioned"
  final_snapshot_identifier = "joaodaibellotestauroraclusterfinalsnapshot"
  enable_http_endpoint      = true

  timeouts {
    create = "15m"
  }

  serverlessv2_scaling_configuration {
    max_capacity = 1.5
    min_capacity = 0.5
  }

  master_username        = var.db_username
  master_password        = var.db_password
  vpc_security_group_ids = [aws_security_group.databse_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name

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

resource "aws_security_group" "databse_security_group" {
  name        = "${var.db_username}-test-aurora-security-group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "191.254.218.115/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.db_username}-test-aurora-subnet-group"
  subnet_ids = var.subnet_ids
}
