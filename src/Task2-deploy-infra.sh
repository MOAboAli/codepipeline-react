#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Configuration Variables
STACK_NAME=reactappstackcloudform
REGION=us-east-2
CLI_PROFILE=mainacc  # Replace with your actual AWS CLI profile name
BUCKET_NAME=reactappbucketcloudform  # Replace with a unique S3 bucket name
INDEX_HTML_PATH=./build/index.html  # Path to your index.html file

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying Task2.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file Task2.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      BucketName=$BUCKET_NAME

# If the deploy succeeded, show the CloudFront domain name and upload index.html
if [ $? -eq 0 ]; then
  echo -e "\n\n=========== Deployment Successful =========="
  aws cloudformation describe-stacks \
    --region $REGION \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME \
    --query "Stacks[0].Outputs" \
    --output table

  echo -e "\n\n=========== index.html Uploaded Successfully =========="
  echo "Access your React app at the CloudFront distribution URL."
fi
