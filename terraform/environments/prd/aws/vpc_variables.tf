locals {
  vpcs = {
    bpzb-tf = {
      name       = "bpzb-tf"
      cidr_block = "10.0.0.0/16"
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
          name              = "public-subnet1-tf"
        }
        public-subnet2 = {
          cidr              = "10.0.2.0/24"
          availability_zone = "eu-west-3b"
          name              = "public-subnet2-tf"
        }
        public-subnet3 = {
          cidr              = "10.0.3.0/24"
          availability_zone = "eu-west-3c"
          name              = "public-subnet3-tf"
        }
      }
      subnets_private = {
        private-subnet1 = {
          cidr              = "10.0.11.0/24"
          availability_zone = "eu-west-3a"
          name              = "private-subnet1-tf"
        }
        private-subnet2 = {
          cidr              = "10.0.12.0/24"
          availability_zone = "eu-west-3b"
          name              = "private-subnet2-tf"
        }
        private-subnet3 = {
          cidr              = "10.0.13.0/24"
          availability_zone = "eu-west-3c"
          name              = "private-subnet3-tf"
        }

      }
    }
  }
}
