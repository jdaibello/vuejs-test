variable "application_name" {
  description = "Application name"
  type = string
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
