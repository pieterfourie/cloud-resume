# DynamoDB (on-demand)
resource "aws_dynamodb_table" "visitors" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.primary_key

  attribute {
    name = var.primary_key
    type = "S"
  }
}

# Seed item (so first call isn't a create)
resource "aws_dynamodb_table_item" "seed" {
  table_name = aws_dynamodb_table.visitors.name
  hash_key   = var.primary_key
  item       = jsonencode({ (var.primary_key) = { S = var.primary_key_value }, "count" = { N = "0" } })
}

# Lambda zip from local file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}

# IAM role + policy
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid     = "DynamoDB"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem"
    ]
    resources = [aws_dynamodb_table.visitors.arn]
  }

  statement {
    sid     = "Logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/${var.project_name}*:*"]
  }
}

resource "aws_iam_policy" "lambda_inline" {
  name   = "${var.project_name}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_inline.arn
}

# Lambda
resource "aws_lambda_function" "counter" {
  function_name = "${var.project_name}-counter"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 5

  environment {
    variables = {
      TABLE_NAME   = aws_dynamodb_table.visitors.name
      PRIMARY_KEY  = var.primary_key
      KEY_VALUE    = var.primary_key_value
      # CORS origin set later to your site URL; for now allow everything during dev:
      ALLOW_ORIGIN = "*"
    }
  }
}

# API Gateway v2 (HTTP API)
resource "aws_apigatewayv2_api" "httpapi" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]     # replace with "https://pfourie.com" when live
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["*"]
    max_age       = 3600
  }
}

resource "aws_apigatewayv2_integration" "lambda_proxy" {
  api_id                 = aws_apigatewayv2_api.httpapi.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.counter.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_count" {
  api_id    = aws_apigatewayv2_api.httpapi.id
  route_key = "GET /count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_proxy.id}"
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.httpapi.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.httpapi.id
  name        = "prod"
  auto_deploy = true
}

