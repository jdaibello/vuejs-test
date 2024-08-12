resource "aws_security_group" "databse_security_group" {
  name        = "${var.db_username}-test-aurora-security-group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # ingress {
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   security_groups = [var.ecs_cluster_ec2_instance_security_group]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.db_username}-test-aurora-subnet-group"
  subnet_ids  = var.subnet_ids
}
