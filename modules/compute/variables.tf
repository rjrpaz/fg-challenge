variable "instance_count" {
  description = "number of instances to be created"
}

variable "region" {
  description = "region to store AWS resources"
}

variable "name" {
  description = "value of 'Name' tag"
}

variable "owner" {
  description = "value of 'Owner' tag"
}

variable "public_sg" {}
variable "public_subnets" {}

variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "lb_target_group_arn" {}

