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
      sg_app_rules_ingress = {
        jh_port         = 0
        jh_protocol     = "-1"
        jh_description  = "all from jumphost"
        alb_port        = 80
        alb_protocol    = "tcp"
        alb_description = "http form ALB"
      }
      sg_app_rules_egress = {
        ports = [
          {
            port        = 0
            protocol    = "-1"
            description = "Allow all"
          }
        ]
        cidrs_ipv4 = ["0.0.0.0/0"]
      }

    }
  }
}

