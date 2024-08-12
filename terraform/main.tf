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

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.4"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.2"
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

module "cluster" {
  source                   = "./modules/cluster"
  application_name         = var.application_name
  ssm_parameter_common_arn = var.ssm_parameter_common_arn
  db_host                  = var.db_host
  db_user                  = var.db_user
  db_password              = var.db_password
  db_security_group_id     = module.database.databse_security_group_id
  vpc_id                   = module.network.vpc_id
  vpc_cidr_block           = module.network.vpc_cidr_block
  vpc_private_subnets      = module.network.private_subnets
  vpc_public_subnets       = module.network.public_subnets
}

module "docker" {
  source           = "./modules/docker"
  application_name = var.application_name
  aws_username     = var.aws_username
}

module "database" {
  source                                  = "./modules/database"
  aws_username                            = var.aws_username
  db_password                             = var.db_password
  ecs_cluster_ec2_instance_security_group = module.cluster.ecs_cluster_ec2_instance_security_group.id
  vpc_id                                  = module.network.vpc_id
  subnet_ids                              = module.network.private_subnets
}

module "network" {
  source           = "./modules/network"
  application_name = var.application_name
}

module "website" {
  source           = "./modules/website"
  application_name = var.application_name
  aws_username     = var.aws_username
  backend_alb_url  = module.cluster.backend_alb_url
  # ca_country       = var.ca_country
  # ca_locality      = var.ca_locality
  # ca_organization  = var.ca_organization
}

# module "code" {
#   source           = "./modules/code"
#   application_name = var.application_name
#   aws_username     = var.aws_username
# }
