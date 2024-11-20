#!/bin/bash

# Exit on any error
set -e

# Step 1: Increment the version and build the ZIP file
echo "Incrementing version and preparing the ZIP..."
npm run prepare-zip

# Step 2: Extract the version from package.json
VERSION=$(node -p "require('../lambda/package.json').version")
echo "Using version: $VERSION"

# Step 3: Change directory
echo "Change directory to terraform.."
cd ../terraform

# Step 4: Run Terraform with the versioned ZIP file
echo "Running Terraform..."
terraform init
terraform plan -var="lambda_version=$VERSION"
terraform apply -var="lambda_version=$VERSION" -auto-approve

# Step 4: Clean up temporary files
echo "Change directory to lambda.."
cd ../lambda

# Step 5: Clean up temporary files
echo "Cleaning up..."
npm run clean

echo "Deployment complete!"

