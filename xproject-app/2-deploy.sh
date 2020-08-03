#!/bin/bash
set -eo pipefail
#Created by Terraform. s3_bucket_lambda_artifacts_name
ARTIFACT_BUCKET="xproject-dev-lambda-artifacts-15308"
sam package --template-file template.yaml --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yaml
sam deploy --template-file out.yaml --stack-name xproject-app --region eu-central-1 --capabilities CAPABILITY_NAMED_IAM