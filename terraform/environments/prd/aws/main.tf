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
  route_cidr           = each.value.route_cidr
  route_nat_gw         = each.value.route_nat_gw
  enable_dns_hostnames = each.value.enable_dns_hostnames
  subnets_public       = each.value.subnets_public
  subnets_private      = each.value.subnets_private
  internet_gw_name     = each.value.internet_gw_name
  nat_gws              = each.value.nat_gws
}

module "alb" {
  for_each                  = local.vpcs
  alb_vpc_id                = module.vpcs[each.key].vpc_id
  alb_vpc_name              = each.key
  alb_vpc_public_subnet_ids = module.vpcs[each.key].vpc_public_subnet_ids

  # ALB
  source                 = "../../../modules/aws/alb/"
  alb_name               = local.alb_name
  alb_internal           = local.alb_internal
  alb_load_balancer_type = local.alb_load_balancer_type
  alb_ip_address_type    = local.alb_ip_address_type
  # SG
  sg_alb_name          = local.sg_alb_name
  sg_alb_description   = local.sg_alb_description
  sg_alb_rules_ingress = local.sg_alb_rules_ingress
  sg_alb_rules_egress  = local.sg_alb_rules_egress
  #  sg_alb_create_before_destroy = local.sg_alb_create_before_destroy
  # TG
  tgs_alb    = local.tgs_alb
  tg_lb_type = local.tg_lb_type
  # listener

}
