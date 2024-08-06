################
### SETTINGS ###
################

terraform {
  required_version = ">= 1.2.0"

    backend "s3" {
    bucket         = "test-joao-daibello-frontend-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "test-joao-daibello-terraform-state-frontend-locking-table"
  }

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

###############
### MODULES ###
###############

module "buckets" {
  source = "./buckets"
}
