resource "aws_security_group" "jh" {
  name        = "${var.sg_jh_name}-${var.asg_vpc_name}"
  description = var.sg_jh_description
  vpc_id      = var.asg_vpc_id

  dynamic "ingress" {
    for_each = var.sg_jh_rules_ingress.ports
    content {
      description      = var.sg_jh_rules_ingress.ports[ingress.key].description
      from_port        = var.sg_jh_rules_ingress.ports[ingress.key].port
      to_port          = var.sg_jh_rules_ingress.ports[ingress.key].port
      protocol         = var.sg_jh_rules_ingress.ports[ingress.key].protocol
      cidr_blocks      = var.sg_jh_rules_ingress.cidrs_ipv4
      ipv6_cidr_blocks = var.sg_jh_rules_ingress.cidrs_ipv6
    }
  }

  dynamic "egress" {
    for_each = var.sg_jh_rules_egress.ports
    content {
      description      = var.sg_jh_rules_egress.ports[egress.key].description
      from_port        = var.sg_jh_rules_egress.ports[egress.key].port
      to_port          = var.sg_jh_rules_egress.ports[egress.key].port
      protocol         = var.sg_jh_rules_egress.ports[egress.key].protocol
      cidr_blocks      = var.sg_jh_rules_egress.cidrs_ipv4
      ipv6_cidr_blocks = var.sg_jh_rules_egress.cidrs_ipv6
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app" {
  name        = "${var.sg_app_name}-${var.asg_vpc_name}"
  description = var.sg_app_description
  vpc_id      = var.asg_vpc_id

  ingress {
    description     = var.sg_app_rules_ingress.jh_description
    from_port       = var.sg_app_rules_ingress.jh_port
    to_port         = var.sg_app_rules_ingress.jh_port
    protocol        = var.sg_app_rules_ingress.jh_protocol
    security_groups = [aws_security_group.jh.id]
  }

  ingress {
    description     = var.sg_app_rules_ingress.alb_description
    from_port       = var.sg_app_rules_ingress.alb_port
    to_port         = var.sg_app_rules_ingress.alb_port
    protocol        = var.sg_app_rules_ingress.alb_protocol
    security_groups = [var.asg_alb_arn]
  }

  dynamic "egress" {
    for_each = var.sg_app_rules_egress.ports
    content {
      description = var.sg_app_rules_egress.ports[egress.key].description
      from_port   = var.sg_app_rules_egress.ports[egress.key].port
      to_port     = var.sg_app_rules_egress.ports[egress.key].port
      protocol    = var.sg_app_rules_egress.ports[egress.key].protocol
      cidr_blocks = var.sg_app_rules_egress.cidrs_ipv4
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


