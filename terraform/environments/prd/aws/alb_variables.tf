locals {
  alb_name               = "ALB"
  alb_internal           = "false"
  alb_load_balancer_type = "application"
  alb_ip_address_type    = "dualstack"
  sg_alb_name            = "SG"
  sg_alb_description     = "Allow 80 and 443 inbound traffic to ALB"
  sg_alb_rules_ingress = {
    ports = [
      {
        port        = 80
        protocol    = "tcp"
        description = "http from internet"
      },
      {
        protocol    = "tcp"
        port        = 443
        description = "https from internet"
      }
    ]
    cidrs_ipv4 = ["0.0.0.0/0"]
    cidrs_ipv6 = ["::/0"]
  }
  sg_alb_rules_egress = {
    ports = [
      {
        port        = 0
        protocol    = "-1"
        description = "Allow all"
      }
    ]
    cidrs_ipv4 = ["0.0.0.0/0"]
    cidrs_ipv6 = ["::/0"]
  }
  #  sg_alb_create_before_destroy = "true" #not usable
  # tg = target group; name = key
  tgs_alb = {
    authz = {
      port     = 80
      protocol = "tcp"
      path     = "/api/v1/authz/health_check"
      matcher  = 200
    }
    authn = {
      port     = 80
      protocol = "tcp"
      path     = "/api/v1/authn/health_check"
      matcher  = 200
    }
    bank = {
      port     = 80
      protocol = "tcp"
      path     = "/api/v1/bank/health_check"
      matcher  = 200
    }
    account = {
      port     = 80
      protocol = "tcp"
      path     = "/api/v1/account/health_check"
      matcher  = 200
    }
  }
  tg_lb_type = "alb"

  alb_listener_80 = {
    port               = 80
    protocol           = "http"
    action_type        = "redirect"
    action_port        = 443
    action_protocol    = "HTTPS"
    action_status_code = "HTTP_301"
  }

  alb_listener_443 = {
    port            = 443
    protocol        = "https"
    ssl_policy      = ""
    certificate_arn = ""
    action_port     = 80
    action_type     = "forward"
  }
}
