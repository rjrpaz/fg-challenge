output "s3-name" {
  value       = module.storage[*].name
  description = "Name of the s3 bucket"
}

output "s3-owner" {
  value       = module.storage[*].owner
  description = "Owner of the s3 bucket"
}

output "instance-name" {
  value       = module.compute[*].name
  description = "Name of the instance"
}

output "instance-owner" {
  value       = module.compute[*].owner
  description = "Owner of the instance"
}

output "instance-public_ip" {
  value = module.compute[*].public_ip
  description = "Public ip of the instance"
}

output "lb_endpoint" {
  value = module.loadbalancing.lb_endpoint
  description = "Dns name of the Loadbalancer endpoint"
}

output "public_sg" {
  value = module.networking.public_sg
}

output "public_subnets" {
  value = module.networking.public_subnets
}

