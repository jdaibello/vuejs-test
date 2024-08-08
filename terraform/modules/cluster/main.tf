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

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.4"
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

data "aws_ssm_parameter" "backend_latest_tag" {
  name = "${var.ssm_parameter_common_arn}/backend/LATEST_TAG"
}
