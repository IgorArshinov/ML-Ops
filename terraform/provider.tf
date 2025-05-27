terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "example" {
  bucket = "some-example-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}