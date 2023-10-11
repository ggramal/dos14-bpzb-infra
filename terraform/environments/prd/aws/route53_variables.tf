locals {
  routes53 = {
    bpzb-tf = {
      vpc_name = "bpzb-tf"
      # zone
      dns_name = "bpzb.smodata.net"
      # A record
      records = {
        a_records = [
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
        ],
        cname_validation_record = {
          record_ttl = 60
          overwrite  = true
        },
        other_records = [
          {
            record_name = ""
            record_type = "CNAME"
            record_ttl  = 300
            records     = [""]
          }
        ]
      }
      # certificate
      domain_name       = "api.bpzb.smodata.net"
      validation_method = "DNS"
    }
  }
}
