#!/bin/bash

BUCKET_NAME="terraform-state-83e7283f-9fb1-4276-84c0-6afa415dd137"
DYNAMO_TABLE="terraform-locks-83e7283f-9fb1-4276-84c0-6afa415dd137"
REGION="eu-central-1"

# S3-Bucket erstellen, falls nicht vorhanden
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION"
    aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
fi

# DynamoDB für Locking erstellen, falls nicht vorhanden
if ! aws dynamodb describe-table --table-name "$DYNAMO_TABLE" 2>/dev/null; then
    aws dynamodb create-table \
        --table-name "$DYNAMO_TABLE" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST
fi

echo "S3-Backend und DynamoDB-Locking wurden erstellt!"
