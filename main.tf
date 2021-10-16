module "storage" {
  source = "./modules/storage"
  region = var.region
  bucket = var.bucket
  name   = var.name
  owner  = var.owner
}

module "compute" {
  source = "./modules/compute"
  region = var.region
  name   = var.name
  owner  = var.owner
}
