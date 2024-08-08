variable "application_name" {
  description = "Application name"
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "asg_desired_size" {
  description = "Desired number of EC2 instances in the ECS cluster"
  type        = number
  default     = 1
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in the ECS cluster"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in the ECS cluster"
  type        = number
  default     = 2
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "joao-daibello-test-backend-ecs-cluster"
}

variable "ec2_image_id" {
  description = "EC2 image ID to launch the ECS cluster"
  type        = string
  default     = "ami-09631896182467be5" # /aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = set(string)
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}
