output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_sg" {
  value = aws_security_group.security_group["public"].id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}
