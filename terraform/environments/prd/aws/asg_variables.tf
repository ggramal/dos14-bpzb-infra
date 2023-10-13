locals {
  asgs = {
    bpzb-tf = {
      vpc_name = "bpzb-tf"
      #asg_name         = "ASG"
      sg_jh_name        = "SG_jumphost"
      sg_jh_description = "Allow ssh inbound traffic to jumphost"
      sg_jh_rules_ingress = {
        ports = [
          {
            port        = 22
            protocol    = "tcp"
            description = "ssh from internet"
          }
        ]
        cidrs_ipv4 = ["0.0.0.0/0"]
        cidrs_ipv6 = ["::/0"]
      }
      sg_jh_rules_egress = {
        ports = [
          {
            port        = 0
            protocol    = "-1"
            description = "Allow all"
          }
        ]
        cidrs_ipv4 = ["0.0.0.0/0"]
      }

      sg_app_name        = "SG_app"
      sg_app_description = "Allow http from alb and all from jumphost inbound traffic to apps"
      sg_app_rules = {
        ingress = [
          { #jh
            port            = 0
            protocol        = "-1"
            description     = "all from jumphost"
            security_groups = ["jh"]
          },
          { #alb
            port            = 80
            protocol        = "tcp"
            description     = "http form ALB"
            security_groups = [module.alb["bpzb-tf"].lb_arn]
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
      }


    }
  }
}

