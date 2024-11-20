terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_iam_role" "ts_lambda_role" {
  name               = "ts_lambda-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_lambda_function" "ts_lambda" {
  filename      = "../lambda/lambda-${var.lambda_version}.zip"
  function_name = "ts_lambda"
  role          = aws_iam_role.ts_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 1024
  timeout       = 300
}

resource "aws_cloudwatch_log_group" "ts_lambda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.ts_lambda.function_name}"
  retention_in_days = 3
}

data "aws_iam_policy_document" "ts_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.ts_lambda_loggroup.arn,
      "${aws_cloudwatch_log_group.ts_lambda_loggroup.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "ts_lambda_role_policy" {
  policy = data.aws_iam_policy_document.ts_lambda_policy.json
  role   = aws_iam_role.ts_lambda_role.id
  name   = "my-lambda-policy"
}

resource "aws_lambda_function_url" "ts_lambda_funtion_url" {
  function_name      = aws_lambda_function.ts_lambda.id
  authorization_type = "NONE"
  cors {
    allow_origins = ["*"]
  }
}
