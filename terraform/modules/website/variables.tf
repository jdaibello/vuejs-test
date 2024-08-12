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

variable "backend_alb_url" {
  description = "Application Load Balancer URL for backend"
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
