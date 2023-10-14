locals {
  asgs = {
    bpzb-tf = {
      vpc_name = "bpzb-tf"
      #asg_name         = "ASG"
      sg_jh_name        = "SG_jumphost"
      sg_jh_description = "Allow ssh inbound traffic to jumphost"
      sg_jh_rules = {
        ingress = [
          {
            port        = 22
            protocol    = "tcp"
            description = "ssh from internet"
            cidrs_ipv4  = ["0.0.0.0/0"]
            cidrs_ipv6  = ["::/0"]
          }
        ]
        egress = [
          {
            port        = 0
            protocol    = "-1"
            description = "Allow all"
            cidrs_ipv4  = ["0.0.0.0/0"]
            cidrs_ipv6  = ["::/0"]
          }
        ]
      }

      sg_app_name        = "SG_app"
      sg_app_description = "Allow http from alb and all from jumphost inbound traffic to apps"
      sg_app_rules = {
        ingress = [
          { #jh
            jh_key      = true
            port        = 0
            protocol    = "-1"
            description = "all from jumphost"
          },
          { #alb
            jh_key          = false
            port            = 80
            protocol        = "tcp"
            description     = "http form ALB"
            security_groups = [module.alb["bpzb-tf"].lb_sg_id]
          }
        ]
        egress = [
          {
            port        = 0
            protocol    = "-1"
            description = "Allow all"
            cidrs_ipv4  = ["0.0.0.0/0"]
          }
        ]
      }
      data_ubuntu = {
        most_recent = true
        owners      = ["099720109477"] # Canonical
        filters = [
          {
            name   = "name"
            values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
          },
          {
            name   = "virtualization-type"
            values = ["hvm"]
          }
        ]
      }
      app_lts = { #launch app tamplates
        authz = {
          name          = "authz-tf"
          instance_type = "t2.micro"
          key_name      = "bank_rsa"
          user_data     = "./config_files/authz.yaml"
        }
        authn = {
          name          = "authn-tf"
          instance_type = "t2.micro"
          key_name      = "bank_rsa"
          user_data     = "./config_files/authn.yaml"
        }
        bank = {
          name          = "bank-tf"
          instance_type = "t2.micro"
          key_name      = "bank_rsa"
          user_data     = "./config_files/bank.yaml"
        }
        account = {
          name          = "account-tf"
          instance_type = "t2.micro"
          key_name      = "bank_rsa"
          user_data     = "./config_files/account.yaml"
        }
        jump_host = {
          name          = "jump-host"
          instance_type = "t2.micro"
          key_name      = "bank_rsa"
          user_data     = "./config_files/jh.yaml"
        }
      }
      app_asgs = { # autoscaling gtoups
        authz = {
          name                    = "bpzb-authz-tf"
          min_size                = 2
          max_size                = 3
          desired_capacity        = 2
          vpc_zone_identifier     = module.vpcs["bpzb-tf"].vpc_private_subnet_ids
          lt_app_name             = "authz"
          tag_key                 = "Name"
          tag_propagate_at_launch = true
        }
        authn = {
          name                    = "bpzb-authn-tf"
          min_size                = 2
          max_size                = 3
          desired_capacity        = 2
          vpc_zone_identifier     = module.vpcs["bpzb-tf"].vpc_private_subnet_ids
          lt_app_name             = "authn"
          tag_key                 = "Name"
          tag_propagate_at_launch = true
        }
        bank = {
          name                    = "bpzb-bank-tf"
          min_size                = 2
          max_size                = 3
          desired_capacity        = 2
          vpc_zone_identifier     = module.vpcs["bpzb-tf"].vpc_private_subnet_ids
          lt_app_name             = "bank"
          tag_key                 = "Name"
          tag_propagate_at_launch = true
        }
        account = {
          name                    = "bpzb-account-tf"
          min_size                = 2
          max_size                = 3
          desired_capacity        = 2
          vpc_zone_identifier     = module.vpcs["bpzb-tf"].vpc_private_subnet_ids
          lt_app_name             = "account"
          tag_key                 = "Name"
          tag_propagate_at_launch = true
        }
        jh = {
          name                    = "bpzb-jh-tf"
          min_size                = 1
          max_size                = 2
          desired_capacity        = 1
          vpc_zone_identifier     = module.vpcs["bpzb-tf"].vpc_public_subnet_ids
          lt_app_name             = "jump_host"
          tag_key                 = "Name"
          tag_propagate_at_launch = true
        }
      }


    }
  }
}

