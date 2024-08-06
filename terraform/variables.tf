variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

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