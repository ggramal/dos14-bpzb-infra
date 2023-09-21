locals {
  vpcs = {
    bpzb-tf = {
      name                 = "bpzb-tf"
      cidr_block           = "10.0.0.0/16"
      enable_dns_hostnames = "true"
      eip_name             = "eip-nat-tf"
      route_cidr           = "0.0.0.0/0"
      route_nat_gw         = "nat_gw1"
      nat_gws = {
        nat_gw1 = {
          name                = "nat-gw1-tf"
          subnet_to_place_nat = "public-subnet3"
        }
      }
      internet_gw_name = "igw-tf"
      subnets_public = {
        public-subnet1 = {
          cidr              = "10.0.1.0/24"
          availability_zone = "eu-west-3a"
          name              = "bpzb-public-eu-west3a-tf"
        }
        public-subnet2 = {
          cidr              = "10.0.2.0/24"
          availability_zone = "eu-west-3b"
          name              = "bpzb-public-eu-west3b-tf"
        }
        public-subnet3 = {
          cidr              = "10.0.3.0/24"
          availability_zone = "eu-west-3c"
          name              = "bpzb-public-eu-west3c-tf"
        }
      }
      subnets_private = {
        private-subnet1 = {
          cidr              = "10.0.11.0/24"
          availability_zone = "eu-west-3a"
          name              = "bpzb-private-eu-west3a-tf"
        }
        private-subnet2 = {
          cidr              = "10.0.12.0/24"
          availability_zone = "eu-west-3b"
          name              = "bpzb-private-eu-west3b-tf"
        }
        private-subnet3 = {
          cidr              = "10.0.13.0/24"
          availability_zone = "eu-west-3c"
          name              = "bpzb-private-eu-west3c-tf"
        }

      }
    }
  }
}
