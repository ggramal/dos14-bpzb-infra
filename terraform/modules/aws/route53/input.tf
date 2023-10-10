variable "zone_name" {
  description = "This is the name of the hosted zone"
  type        = string
}

variable "records" {
  description = "map of records for aws route53 A records "
  type = list(
    object(
      {
        record_name = string
        record_type = string
        aliases = list(
          object(
            {
              alb_dns_name  = string
              alb_zone_id   = string
              target_health = bool
            }
          )
        )
      }
    )
  )
}

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

