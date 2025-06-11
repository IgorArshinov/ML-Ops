resource "aws_s3_bucket" "s3" {
  bucket        = var.bucket
  tags          = var.tags
  force_destroy = true
}
