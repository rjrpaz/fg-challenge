output "name" {
  value = aws_s3_bucket.bucket.tags_all["Name"]
}

output "owner" {
  value = aws_s3_bucket.bucket.tags_all["Owner"]
}

