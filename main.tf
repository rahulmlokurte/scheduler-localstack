provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

resource "aws_cloudwatch_event_rule" "scheduled_event" {
  name                = "my_scheduled_event"
  description         = "My scheduled event rule"
  schedule_expression = "rate(1 minutes)"

  # Uncomment the following line if you want to enable the rule immediately
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduled_event.name
  target_id = "my_lambda_function"
  arn       = aws_lambda_function.my_lambda_function.arn
  input     = <<JSON
            {
  "number1": 4,
  "number2": 5
}
JSON
}

data "archive_file" "my_lambda_function_archive" {
  type        = "zip"
  source_file = "${path.module}/code/lambda_function.py"
  output_path = "my_lambda_function.zip"
}


resource "aws_lambda_function" "my_lambda_function" {
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  filename         = "my_lambda_function.zip"
  source_code_hash = data.archive_file.my_lambda_function_archive.output_base64sha256
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_event.arn
}


resource "aws_iam_role" "lambda_role" {
  name = "my_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  inline_policy {
    name = "cloudwatch_logs_policy"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  }
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.lambda_log_group.name
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.my_lambda_function.function_name}"
}

