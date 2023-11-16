locals {
  bpzb_rds = {
    engine              = "postgres"
    storage             = "20"
    db_subnet_name      = "subnet-db"
    publicly_accessible = false
    name                = "bpzb"
    engine_version      = "15.3"
    instance_class      = "db.t3.micro"
    username            = "bpzb"
    password            = random_password.password.result
    identifier          = "bpzb-rds-tf"
    final_snap          = "true"
    sg_name             = "sg-rds-db"
  }
  sg_rds = {
    ingress = {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
    }
  }
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "password" {
  value     = local.bpzb_rds.password
  sensitive = true
}