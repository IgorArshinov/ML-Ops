environment = "tst"
aws_region  = "eu-west-1"

s3_buckets = [
  {
    key = "mlops-datastore-9876"
    tags = {}
    rule = {
      id = "data"
      expiration = {
        days = 1
      }
    }
  },
  {
    key = "mlops-models-9876"
    tags = {}
  }
]