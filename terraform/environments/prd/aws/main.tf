terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
  backend "s3" {
    bucket         = "dos14-tf-state"
    key            = "bpzb/prd/aws/state.tfstate"
    dynamodb_table = "tf_state_bpzb"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region = local.aws_region
}

module "vpcs" {
  source               = "../../../modules/aws/vpc/"
  for_each             = local.vpcs
  name                 = each.value.name
  cidr_block           = each.value.cidr_block
  eip_name             = each.value.eip_name
  route_cidr           = each.value.route_cidr
  route_nat_gw         = each.value.route_nat_gw
  enable_dns_hostnames = each.value.enable_dns_hostnames
  subnets_public       = each.value.subnets_public
  subnets_private      = each.value.subnets_private
  internet_gw_name     = each.value.internet_gw_name
  nat_gws              = each.value.nat_gws
}
