module "storage" {
  source = "./modules/storage"
  region = var.region
  bucket = var.bucket
  name   = var.name
  owner  = var.owner
}

module "networking" {
  source = "./modules/networking"
  region = var.region
  vpc_cidr = local.vpc_cidr
  public_cidrs = local.public_cidrs
  availability_zones = var.availability_zones
  access_ip = var.access_ip
  security_groups = local.security_groups
  name   = var.name
  owner  = var.owner
}

module "loadbalancing" {
  source = "./modules/loadbalancing"
  region = var.region
  public_sg = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  tg_port                = "80"
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
  name   = var.name
  owner  = var.owner
}

module "compute" {
  source = "./modules/compute"
  instance_count = local.instance_count
  region = var.region
  name   = var.name
  owner  = var.owner
  public_sg              = module.networking.public_sg
  public_subnets         = module.networking.public_subnets
  key_name               = "rsa_key"
  public_key_path        = "/home/roberto/.ssh/id_rsa.pub"
  private_key_path        = "/home/roberto/.ssh/id_rsa"
  lb_target_group_arn    = module.loadbalancing.lb_target_group_arn
}


