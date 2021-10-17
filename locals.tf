locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  public_cidrs = ["10.123.1.0/24", "10.123.2.0/24"]
}

locals {
  instance_count = 2
}

locals {
  security_groups = {
    public = {
      name = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from = 22
          to = 22
          protocol = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from = 80
          to = 80
          protocol = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}

