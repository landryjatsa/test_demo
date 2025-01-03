terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

module "state_bucket" {
  source = "./modules/state/s3"
  state_bucket_name = "terraform-state-eks-cluster"
}

module "state_lock" {
  source = "./modules/state/dynamodb"
  table_name = "terraform-state-lock"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  azs               = var.availability_zones
  private_subnets   = var.private_subnet_cidrs
  public_subnets    = var.public_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids

  node_groups = var.node_groups
}