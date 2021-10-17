output "name" {
  value = aws_instance.web[*].tags_all["Name"]
}

output "owner" {
  value = aws_instance.web[*].tags_all["Owner"]
}

output "public_ip" {
  value = aws_instance.web[*].public_ip
}
