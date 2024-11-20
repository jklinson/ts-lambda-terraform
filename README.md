# README

## Project Overview
This project demonstrates a serverless setup using AWS Lambda and Terraform. The Lambda function is written in TypeScript, and Terraform is used for infrastructure provisioning. The Lambda function version is automatically incremented during deployment, and the generated artifact is zipped for deployment. A GitHub Actions workflow is provided to automate the deployment pipeline.

---

## Project Structure

- **`lambda/`**: Contains the TypeScript source code, build configuration, and deployment scripts for the AWS Lambda function.
  - **`src/`**: TypeScript source code for the Lambda function.
  - **`deploy.sh`**: Deployment script for automating versioning and deployment.
  - **`package.json`**: Defines build, deploy, and cleanup scripts for the Lambda function.
  - **`tsconfig.json`**: TypeScript compiler configuration.

- **`terraform/`**: Contains Terraform configuration files for AWS infrastructure provisioning.
  - **`main.tf`**: Terraform resources for Lambda, IAM roles, and CloudWatch.
  - **`variable.tf`**: Variable definition for Lambda function version.

- **`.github/workflows/`**: Contains GitHub Actions workflow files for CI/CD.
  - **`deploy.yml`**: Automates the build, test, and deployment process.

---

## Prerequisites

- **AWS CLI**: Installed and configured with the appropriate access.
- **Node.js**: For building and zipping the Lambda function.
- **Terraform**: Installed for infrastructure management.

---

## Setup Instructions

### 1. Install Dependencies
Navigate to the `lambda/` directory and install the required dependencies:

```bash
cd lambda
npm install
```

### 2. Increment Version and Build
Use the following command to increment the version, compile the TypeScript code, and prepare the zipped artifact:

```bash
npm run prepare-zip
```

This creates a zip file in the `lambda/` directory named `lambda-<version>.zip`.

### 3. Deploy with Terraform
Run the deployment script to provision resources using Terraform:

```bash
npm run deploy
```

The script performs the following:
1. Increments the Lambda function version.
2. Creates a zip file with the compiled code and dependencies.
3. Runs Terraform to deploy the resources using the updated version.

### 4. Clean Up
After deployment, clean up temporary files:

```bash
npm run clean
```

---

## Updating the Lambda Function
To update the Lambda function:
1. Modify the TypeScript code in `src/`.
2. Run `npm run deploy` to rebuild and redeploy the function with a new version.

---

## Terraform Variables

- **`lambda_version`**: Defines the Lambda function version for Terraform. This is automatically updated during deployment.

---

## GitHub Actions Workflow

### Workflow Overview
The GitHub Actions workflow automates the CI/CD process for the Lambda function. It includes:
1. Installing dependencies.
2. Running the build and incrementing the version.
3. Packaging the Lambda function.
4. Deploying resources using Terraform.

### Workflow File: `.github/workflows/deploy.yml`

```yaml

```

---

## Notes
- Ensure AWS credentials are configured in GitHub Actions secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
- The workflow is triggered on every push to the `main` branch.
- Versioning and deployment are fully automated through the workflow.