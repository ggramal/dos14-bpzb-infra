resource "aws_security_group" "jh" {
  name        = "${var.sg_jh_name}-${var.vpc_name}"
  description = var.sg_jh_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_jh_rules.ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidrs_ipv4
      ipv6_cidr_blocks = ingress.value.cidrs_ipv6
    }
  }

  dynamic "egress" {
    for_each = var.sg_jh_rules.egress
    content {
      description      = egress.value.description
      from_port        = egress.value.port
      to_port          = egress.value.port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidrs_ipv4
      ipv6_cidr_blocks = egress.value.cidrs_ipv6
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app" {
  name        = "${var.sg_app_name}-${var.vpc_name}"
  description = var.sg_app_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_app_rules.ingress
    content {
      description     = ingress.value.description
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.jh_key ? [aws_security_group.jh.id] : ingress.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = var.sg_app_rules.egress
    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidrs_ipv4
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_security_group.jh]
}


data "aws_ami" "ubuntu" {
  most_recent = var.data_ubuntu.most_recent
  dynamic "filter" {
    for_each = var.data_ubuntu.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
  owners = var.data_ubuntu.owners
}

resource "aws_launch_template" "app" {
  for_each               = var.app_lts
  name                   = each.value.name
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  key_name               = each.value.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  lifecycle {
    create_before_destroy = true
  }
  user_data = filebase64(each.value.user_data)
}


