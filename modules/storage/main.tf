resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    Name  = var.name
    Owner = var.owner
  }
}
