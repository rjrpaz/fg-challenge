module "storage" {
  source = "./storage"
  region = var.aws_region
  bucket = var.bucket
  name   = var.tag.name
  owner  = var.tag.owner
}

module "compute" {
  source = "./compute"
  region = var.aws_region
  name   = var.tag.name
  owner  = var.tag.owner
}
