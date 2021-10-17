variable "region" {}
variable "name" {}
variable "owner" {}
variable "vpc_cidr" {}
variable "public_cidrs" {
  type = list
}
variable "availability_zones" {
  type = list
}
variable "access_ip" {}
variable "security_groups" {}
