variable "vpc_id" {
  description = "vpc id"
}

variable "vpc_name" {
  description = "vpc name"
}

#variable "alb_arn" {
#  description = "The ARN of the load balancer (matches id)"
#}

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

variable "sg_app_rules" {
  description = "rules for app security group"
  type = object(
    {
      ingress = list(
        object(
          {
            port            = number
            protocol        = string
            description     = string
            cidrs_ipv4      = optional(list(string))
            security_groups = optional(list(string))
          }
        )
      )
      egress = list(
        object(
          {
            port            = number
            protocol        = string
            description     = string
            cidrs_ipv4      = optional(list(string))
            security_groups = optional(list(string))
          }
        )
    ) }
  )
}

variable "data_ubuntu" {
  description = ""
  type = object(
    {
      most_recent = bool
      owners      = list(string)
      filters = list(
        object(
          {
            name   = string
            values = list(string)
          }
        )
      )
    }
  )
}

variable "app_lts" {
  description = ""
  type = map(
    object(
      {
        name          = string
        instance_type = string
        key_name      = string
        user_data     = string
      }
    )
  )
}


