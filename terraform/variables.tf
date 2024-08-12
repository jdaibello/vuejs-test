variable "application_name" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_username" {
  description = "AWS username"
  type        = string
}

# variable "ca_country" {
#   description = "CA country"
#   type        = string
# }

# variable "ca_locality" {
#   description = "CA locality"
#   type        = string
# }

# variable "ca_organization" {
#   description = "CA organization"
#   type        = string
# }

variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}

variable "dockerhub_password" {
  description = "Docker Hub password"
  type        = string
  sensitive   = true
}

variable "dockerhub_email" {
  description = "Docker Hub email"
  type        = string
}

variable "db_host" {
  description = "Aurora DB host"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Aurora DB user"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "ec2_image_id" {
  description = "EC2 image ID to launch the ECS cluster"
  type        = string
  default     = "t3.medium"
}

variable "ecr_latest_tag" {
  description = "ECR latest tag"
  type        = string
}

variable "ssm_parameter_common_arn" {
  description = "SSM parameter store common ARN"
  type        = string
}
