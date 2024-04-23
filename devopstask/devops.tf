provider "aws" {
  region = "us-east-1"   
}

resource "aws_sqs_queue" "devops_queue" {
  name                      = "devops-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 345600  # 4 days
}
 
resource "aws_s3_bucket" "devops_bucket" {
  bucket_prefix = "devops-bucket-"
}
 
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}
 
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda function execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject"
      ],
      Resource  = [
        aws_s3_bucket.devops_bucket.arn,
        "${aws_s3_bucket.devops_bucket.arn}/*"
      ]
    }]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "cloudwatch_logs_policy"
  description = "Policy for CloudWatch Logs access"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource  = "arn:aws:logs:*:*:*"
    }]
  })
}

# Attach CloudWatch Logs Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}


resource "aws_lambda_function" "devops_lambda" {
  function_name    = "devops_lambda_function_test"
  filename         = "lambda(awsconsole).zip"  # Path to your Lambda deployment package
  handler          = "lambda(awsconsole).lambda_handler"  # Change if your handler file is named differently
  runtime          = "python3.8"  # Change to your desired runtime
  role             = aws_iam_role.lambda_role.arn  # ARN of your existing IAM role for Lambda
  source_code_hash = filebase64sha256("lambda(awsconsole).zip")  # Calculate the hash of your deployment package
  
  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.devops_queue.id
      S3_BUCKET_NAME = aws_s3_bucket.devops_bucket.bucket
    }
  }
}

resource "aws_iam_policy" "sqs_policy" {
  name = "sqs_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = [
         "*"
      ],
      Resource  = aws_sqs_queue.devops_queue.arn
    }]
  })
}
 
resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}
 
resource "aws_lambda_event_source_mapping" "devops_lambda_trigger" {
  event_source_arn  = aws_sqs_queue.devops_queue.arn
  function_name     = aws_lambda_function.devops_lambda.function_name  
}