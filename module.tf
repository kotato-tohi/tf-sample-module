terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

## VPC
module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "hogehoge"
  enable_dns     = true
  tag_name       = var.tag_name
  tag_cost       = var.tag_cost
}


module "sbn" {
  source      = "./modules/subnet"
  vpc_id      = module.vpc.id
  cidr_block  = module.vpc.cidr_block
  igw         = module.vpc.igw
  az          = var.az
  az_list     = var.az_list
  pub_ip      = true
  pub_sbn_cnt = var.pub_sbn_cnt
  pvt_sbn_cnt = var.pvt_sbn_cnt
  tag_name    = var.tag_name
  tag_cost    = var.tag_cost
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.id
  tag_name = var.tag_name
  tag_cost = var.tag_cost
}

module "ec2" {
  source       = "./modules/ec2"
  ec2_ami      = var.ec2_ami
  ec2_type     = var.ec2_type
  ec2_key      = var.ec2_key
  ec2_instance = var.pub_sbn_cnt
  ec2_sgs      = module.sg.ec2_sg
  ec2_subnet   = module.sbn.pub_sbn
  ec2_pub_ip   = true
  tag_name     = var.tag_name
  tag_cost     = var.tag_cost
}