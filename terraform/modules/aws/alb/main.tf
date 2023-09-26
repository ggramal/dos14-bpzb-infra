resource "aws_lb" "bpzb" {
  name               = "${var.alb_name}-${var.alb_vpc_name}"
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.alb_vpc_public_subnet_ids
  ip_address_type    = var.alb_ip_address_type
  depends_on         = [aws_security_group.alb]
}

resource "aws_security_group" "alb" {
  name        = "${var.sg_alb_name}-${var.alb_name}-${var.alb_vpc_name}"
  description = var.sg_alb_description
  vpc_id      = var.alb_vpc_id

  dynamic "ingress" {
    for_each = var.sg_alb_rules_ingress.ports

    content {
      description      = var.sg_alb_rules_ingress.ports[ingress.key].description
      from_port        = var.sg_alb_rules_ingress.ports[ingress.key].port
      to_port          = var.sg_alb_rules_ingress.ports[ingress.key].port
      protocol         = var.sg_alb_rules_ingress.ports[ingress.key].protocol
      cidr_blocks      = var.sg_alb_rules_ingress.cidrs_ipv4
      ipv6_cidr_blocks = var.sg_alb_rules_ingress.cidrs_ipv6
    }
  }

  dynamic "egress" {
    for_each = var.sg_alb_rules_egress.ports

    content {
      description      = var.sg_alb_rules_egress.ports[egress.key].description
      from_port        = var.sg_alb_rules_egress.ports[egress.key].port
      to_port          = var.sg_alb_rules_egress.ports[egress.key].port
      protocol         = var.sg_alb_rules_egress.ports[egress.key].protocol
      cidr_blocks      = var.sg_alb_rules_egress.cidrs_ipv4
      ipv6_cidr_blocks = var.sg_alb_rules_egress.cidrs_ipv6
    }
  }

  lifecycle {
    create_before_destroy = true #var.sg_alb_create_before_destroy
  }
}

resource "aws_lb_target_group" "alb" {
  for_each    = var.tgs_alb
  name        = "${var.alb_name}-${each.key}-${var.alb_vpc_name}"
  target_type = var.tg_lb_type
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.alb_vpc_id
  #  deregistration_delay = 10 #seconds
  health_check {
    path    = each.value.path
    matcher = each.value.matcher
  }
}

#resource "aws_lb_listener" "alb" {
#  load_balancer_arn = aws_lb.bpzb.arn
#  port              = "80"
#  protocol          = "TCP"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#  default_action {
#  type             = "forward"
#  target_group_arn = aws_lb_target_group.alb.arn
#}
#}
