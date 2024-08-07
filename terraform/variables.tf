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
