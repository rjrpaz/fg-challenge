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

