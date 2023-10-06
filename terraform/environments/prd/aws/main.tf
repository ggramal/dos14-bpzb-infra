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
  for_each                  = local.albs
  alb_vpc_id                = module.vpcs[each.value.vpc_name].vpc_id
  alb_vpc_name              = each.value.vpc_name
  alb_vpc_public_subnet_ids = module.vpcs[each.value.vpc_name].vpc_public_subnet_ids
  #  certificate_arn           = module.route53[each.value.vpc_name].certificate_arn

  # ALB
  source                 = "../../../modules/aws/alb/"
  alb_name               = each.value.alb_name
  alb_internal           = each.value.alb_internal
  alb_load_balancer_type = each.value.alb_load_balancer_type
  alb_ip_address_type    = each.value.alb_ip_address_type
  # SG
  sg_alb_name          = each.value.sg_alb_name
  sg_alb_description   = each.value.sg_alb_description
  sg_alb_rules_ingress = each.value.sg_alb_rules_ingress
  sg_alb_rules_egress  = each.value.sg_alb_rules_egress
  #  sg_alb_create_before_destroy = local.sg_alb_create_before_destroy
  # TGs
  tgs_alb    = each.value.tgs_alb
  tg_lb_type = each.value.tg_lb_type
  # listeners
  alb_listener_80  = each.value.alb_listener_80
  alb_listener_443 = each.value.alb_listener_443
  # listeners rules
  alb_rules = each.value.alb_rules
}

module "route53" {
  source   = "../../../modules/aws/route53/"
  for_each = local.routes53
  # alb outputs
  route53_alb_dns_name = module.alb[each.value.vpc_name].dns_name
  route53_alb_zone_id  = module.alb[each.value.vpc_name].zone_id
  # zone
  zone_name = each.value.dns_name
  # A_record
  a_record_name = each.value.record_name
  a_record_type = each.value.record_type
  #a_record_ttl        = each.value.record_ttl
  a_target_health = each.value.evaluate_target_health
  # certificate
  cert_domain_name       = each.value.domain_name
  cert_validation_method = each.value.validation_method
  # cname record
  cname_overwrite = each.value.cname_overwrite
  cname_ttl       = each.value.cname_ttl
}
