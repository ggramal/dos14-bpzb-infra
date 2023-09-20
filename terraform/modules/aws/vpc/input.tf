variable "name" {
  description = "vpc name"
  type        = string
}

variable "cidr_block" {
  description = "vpc cidr block"
  type        = string
}

variable "nat_gws" {
  description = "nat gateways"
  type = map(
    object(
      {
        name                = string
        subnet_to_place_nat = string
      }
    )
  )
}

variable "internet_gw_name" {
  description = "vpc internet gateway name"
  type        = string
}

variable "subnets_public" {
  description = "vpc public subnets"
  type = map(
    object(
      {
        cidr              = string
        name              = string
        availability_zone = string
      }
    )
  )
}

variable "subnets_private" {
  description = "vpc private subnets"
  type = map(
    object(
      {
        cidr              = string
        name              = string
        availability_zone = string
      }
    )
  )
}
