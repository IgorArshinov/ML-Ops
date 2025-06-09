environment = "dev"
aws_region  = "eu-west-1"

s3_buckets = [
  {
    key = "mlops-datastore-9876"
    tags = {}
  },
  {
    key = "mlops-models-9876"
    tags = {}
  }
]

ecr_repositories = [
  {
    key                  = "mlops-docker-repository"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration = {
      scan_on_push = true
    }
    tags = {}
  }
]