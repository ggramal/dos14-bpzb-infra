variable "alb_dns_name" {
  description = "The DNS name of the load balancer"
}

variable "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
}

variable "zone_name" {
  description = "This is the name of the hosted zone"
  type        = string
}

variable "records" {
  description = ""
  type = map(
    object(
      {
        record_name   = string
        record_type   = string
        target_health = bool
      }
    )
  )
}

#variable "a_record_type" {
#  description = "The record type"
#  type        = string
#}

#variable "a_target_health" {
#  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set"
#  type        = bool
#}

variable "cert_domain_name" {
  description = "Domain name for which the certificate should be issued"
  type        = string
}

variable "cert_validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid"
  type        = string
}

variable "cname_overwrite" {
  description = "Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record"
  type        = bool
}

variable "cname_ttl" {
  description = "The TTL of the record"
  type        = number
}

