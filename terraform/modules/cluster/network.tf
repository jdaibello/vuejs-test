resource "aws_security_group" "ecs_cluster_ec2_instance_security_group" {
  name        = "${var.application_name}-ecs-cluster-ec2-instance-sg"
  description = "Security group for ECS cluster EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
