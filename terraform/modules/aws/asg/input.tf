variable "vpc_id" {
  description = "vpc id"
}

variable "vpc_name" {
  description = "vpc name"
}

variable "alb_arn" {
  description = "The ARN of the load balancer (matches id)"
}

variable "sg_jh_name" {
  description = "jumphost instance security group name"
  type        = string
}

variable "sg_jh_description" {
  description = "description for security group jumphost instance"
  type        = string
}

variable "sg_jh_rules_ingress" {
  description = "ingress rules for jumphost security group"
  type = object(
    {
      ports = list(
        object(
          {
            port        = number
            protocol    = string
            description = string
          }
        )
      )
      cidrs_ipv4 = list(string)
      cidrs_ipv6 = optional(list(string))
    }
  )
}

variable "sg_jh_rules_egress" {
  description = "egress rules for jumphost security group"
  type = object(
    {
      ports = list(
        object(
          {
            port        = number
            description = string
            protocol    = string
          }
        )
      )
      cidrs_ipv4 = list(string)
      cidrs_ipv6 = optional(list(string))
    }
  )
}

variable "sg_app_name" {
  description = "app instance security group name"
  type        = string
}

variable "sg_app_description" {
  description = "description for security group app instance"
  type        = string
}

variable "sg_app_rules_ingress" {
  description = "ingress rules for app security group"
  type = object(
    {
      jh_port         = number
      jh_protocol     = string
      jh_description  = string
      alb_port        = number
      alb_protocol    = string
      alb_description = string
    }
  )
}

variable "sg_app_rules_egress" {
  description = "egress rules for app security group"
  type = object(
    {
      ports = list(
        object(
          {
            description = string
            port        = number
            protocol    = string
          }
        )
      )
      cidrs_ipv4 = list(string)
    }
  )
}

