locals {
  routes53 = {
    bpzb-tf = {
      vpc_name = "bpzb-tf"
      # zone
      dns_name = "bpzb.smodata.net"
      # A record
      record_name            = "api.bpzb.smodata.net"
      record_type            = "A"
      evaluate_target_health = true
      # certificate
      domain_name       = "api.bpzb.smodata.net"
      validation_method = "DNS"
      # cname
      cname_overwrite = true
      cname_ttl       = 60
    }
  }
}
