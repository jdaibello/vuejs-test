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
  source = "./modules/buckets"
}

module "docker" {
  source           = "./modules/docker"
  application_name = var.application_name
  aws_username     = var.aws_username
}

module "database" {
  source      = "./modules/database"
  db_password = var.db_password
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.private_subnets
}

module "network" {
  source           = "./modules/network"
  application_name = var.application_name
}

module "website" {
  source           = "./modules/website"
  application_name = var.application_name
  aws_username     = var.aws_username
  # ca_country       = var.ca_country
  # ca_locality      = var.ca_locality
  # ca_organization  = var.ca_organization
}

# module "code" {
#   source           = "./modules/code"
#   application_name = var.application_name
#   aws_username     = var.aws_username
# }
