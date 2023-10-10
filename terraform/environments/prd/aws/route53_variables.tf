locals {
  routes53 = {
    bpzb-tf = {
      vpc_name = "bpzb-tf"
      # zone
      dns_name = "bpzb.smodata.net"
      # A record
      records = [
        {
          record_name = "api.bpzb.smodata.net"
          record_type = "A"
          aliases = [
            {
              alb_dns_name  = module.alb["bpzb-tf"].dns_name
              alb_zone_id   = module.alb["bpzb-tf"].zone_id
              target_health = true
            }
          ]
        }
      ]
      # certificate
      domain_name       = "api.bpzb.smodata.net"
      validation_method = "DNS"
      # cname
      cname_overwrite = true
      cname_ttl       = 60
    }
  }
}
