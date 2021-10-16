variable "aws_region" {
  default = "us-east-1"
}

variable "tag" {
  type = map(any)
  default = {
    name  = "Flugel"
    owner = "InfraTeam"
  }
}

variable "bucket" {
  default = "rjrpaz-fg"
}
