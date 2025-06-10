import boto3
import yaml

def process_config():
    with open('../config.yml', 'r') as file:
        config = yaml.safe_load(file)

    s3_client = boto3.client('s3')
    s3_resource = boto3.resource('s3')
    model_id = config.get("model").get("id")
    model_file = config.get("model").get("file")
    full_file_name = config.get("model").get("full_file_name")

    dev_bucket = config.get("bucket").get("dev")
    bucket = s3_resource.Bucket(dev_bucket)

    for obj in bucket.objects.all():
        if model_id in obj.key and obj.key.endswith(model_file):
            s3_client.download_file(dev_bucket, obj.key, full_file_name)

    bucket_name = config.get("bucket").get("prd")
    object_key = full_file_name

    response = s3_client.put_object(
        Bucket=bucket_name,
        Key=object_key,
        Body=model_file
    )
    return response  # optionally return response for further validation