variable "dns_name" {
  description = "This is the name of the hosted zone"
  type        = string
}

variable "dns_private_zone" {
  description = "Aws private zone or internet"
  type        = bool
}

variable "dns_record_name" {
  description = "The name of the record"
  type        = string
}

variable "dns_record_type" {
  description = "The record type"
  type        = string
}

variable "dns_record_ttl" {
  description = "The TTL of the record"
  type        = number
}

variable "dns_validation_method" {
  description = "The method of validation DNS"
  type        = string
}

