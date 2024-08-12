################
### SETTINGS ###
################

terraform {
  required_version = ">= 1.2.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

########################
### PROVIDER CONFIGS ###
########################

provider "aws" {
  region = var.aws_region
}

############
### DATA ###
############

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "availability_zones" {}

###############
### OUTPUTS ###
###############

output "databse_security_group_id" {
  value = aws_security_group.databse_security_group.id
}
