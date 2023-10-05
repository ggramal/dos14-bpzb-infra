locals {
  routes53 = {
    bpzb-tf = {
      name         = "bpzb.smodata.net"
      private_zone = false


      record_name = "api.bpzb.smodata.net"
      record_type = "CNAME"
      record_ttl  = 300


      domain_name       = "api.bpzb.smodata.net"
      validation_method = "DNS"

    }
  }
}
