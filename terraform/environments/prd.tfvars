environment = "prd"
aws_region  = "eu-west-1"

s3_buckets = [
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

# apprunner_services = [
#   {
#     key = "mlops-app-service"
#     source_configuration = {
#       image_repository = {
#         image_identifier      = "859012633230.dkr.ecr.eu-west-1.amazonaws.com/ecr-mlops-docker-repository-prd:latest"
#         image_repository_type = "ECR"
#         image_configuration = {
#           port = 8989
#         }
#       }
#       auto_deployments_enabled = true
#     }
#     tags = {}
#   }
# ]