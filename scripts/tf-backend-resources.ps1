# Define a helper function to check the exit status and exit on error
function Check-ExitStatus {
    param (
        [string]$ErrorMsg
    )
    if ($LASTEXITCODE -ne 0) {
        Write-Error "$ErrorMsg (Exit Code: $LASTEXITCODE)"
        Exit 1
    }
}

# Specify the username for the new IAM user
$USER_NAME = "terraform_user"
#
## Create IAM User and capture the JSON response
#$userResponseJson = aws iam get-user --user-name $USER_NAME | Out-String
##Check-ExitStatus "Failed to create IAM user."
#$userResponse = $userResponseJson | ConvertFrom-Json
#
## Extract the User ARN from the response
#$USER_ARN = $userResponse.User.Arn
#
## Attach Admin Access Policy to IAM User
#aws iam attach-user-policy --user-name $USER_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess | Out-Null
#Check-ExitStatus "Failed to attach Admin Access Policy to IAM user."
#
## Create Access and Secret Access Keys and capture the response as JSON
#$credsJsonStr = aws iam create-access-key --user-name $USER_NAME | Out-String
#Check-ExitStatus "Failed to create Access and Secret Access Keys."
#$credsJson = $credsJsonStr | ConvertFrom-Json
#
## Extract Access Key and Secret Access Key
#$ACCESS_KEY = $credsJson.AccessKey.AccessKeyId
#$SECRET_KEY = $credsJson.AccessKey.SecretAccessKey
#
## Create a text file to export keys
#"Access Key: $ACCESS_KEY" | Out-File -FilePath terraform_user_accessKeys.txt -Append
#"Secret Access Key: $SECRET_KEY" | Out-File -FilePath terraform_user_accessKeys.txt -Append

# Create S3 Bucket
$S3_BUCKET_NAME = "tf-remote-backends-ehb-354987132465"
#aws s3 mb "s3://$S3_BUCKET_NAME" --region "eu-west-3" | Out-Null
##Check-ExitStatus "Failed to create S3 bucket."
#
## Enable Versioning for S3 Bucket
#aws s3api put-bucket-versioning --bucket $S3_BUCKET_NAME --versioning-configuration Status=Enabled | Out-Null
#Check-ExitStatus "Failed to apply versioning policy to the S3 bucket."
#
## Create DynamoDB Table for Terraform locks
#aws dynamodb create-table `
#  --table-name "tf-lock-table-ehb" `
#  --attribute-definitions AttributeName=LockID,AttributeType=S `
#  --key-schema AttributeName=LockID,KeyType=HASH `
#  --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 `
#  --region "eu-north-1" | Out-Null
#Check-ExitStatus "Failed to create DynamoDB table."

# Define paths relative to the script's location for the policy file
$scriptPath    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$s3PolicyPath  = Join-Path $scriptPath "s3-policy.json"
$newPolicyPath = Join-Path $scriptPath "new-policy.json"

# Read s3-policy.json, perform the necessary string replacements:
# - Replace "RESOURCE" with "arn:aws:s3:::[S3_BUCKET_NAME]"
# - Replace "KEY" with "terraform.tfstate"
# - Replace "ARN" with the IAM user's ARN
#try {
#    $content = Get-Content -Path $s3PolicyPath -Raw
#} catch {
#    Write-Error "Failed to read s3-policy.json: $_"
#    Exit 1
#}
#
#$content = $content -replace "RESOURCE", "arn:aws:s3:::$S3_BUCKET_NAME"
#$content = $content -replace "KEY", "terraform.tfstate"
#$content = $content -replace "ARN", $USER_ARN

#try {
#    $content | Out-File -FilePath $newPolicyPath -Encoding UTF8
#} catch {
#    Write-Error "Failed to execute JSON transformation: $_"
#    Exit 1
#}

# Apply the modified bucket policy from the new JSON file
#aws s3api put-bucket-policy --bucket $S3_BUCKET_NAME --policy "file://$newPolicyPath" | Out-Null
#aws s3api put-bucket-policy --bucket $S3_BUCKET_NAME --policy "file:///art/PyCharm/projects/Postgraduaat-Artificial-Intelligence/Machine-Learning-Operations/mlops-course-2025/mlops-course-02/scripts/new-policy.json" | Out-Null
#aws s3api put-bucket-policy --bucket $S3_BUCKET_NAME --policy "file://new-policy.json" | Out-Null
aws s3api put-bucket-policy --bucket $S3_BUCKET_NAME --policy "file://H:/art/PyCharm/projects/Postgraduaat-Artificial-Intelligence/Machine-Learning-Operations/mlops-course-2025/mlops-course-02/scripts/new-policy.json" | Out-Null
#Check-ExitStatus "Failed to apply policy to the S3 bucket."

# Clean up the temporary policy file
#Remove-Item -Path $newPolicyPath -Force

# Output confirmation messages
Write-Host "IAM User created successfully. Username: $USER_NAME"
Write-Host "S3 Bucket created successfully: $S3_BUCKET_NAME (Versioning enabled)"
Write-Host "Access and Secret Access Keys exported to terraform_user_accessKeys.txt"
