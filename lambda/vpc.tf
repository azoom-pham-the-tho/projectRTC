
resource "aws_vpc" "rtc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_fe" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.rtc_vpc.id
}
resource "aws_subnet" "subnet_be" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.rtc_vpc.id
}

resource "aws_api_gateway_rest_api" "rest_api_fe" {
  name              = "rtc-fe"
  description       = "An example API Gateway"
}
resource "aws_api_gateway_rest_api" "rest_api_be" {
  name              = "rtc-be"
  description       = "An example API Gateway"
}

resource "aws_api_gateway_resource" "gateway_resource_fe" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_fe.id
  parent_id   = aws_api_gateway_rest_api.rest_api_fe.root_resource_id
  path_part   = "fe"
}
resource "aws_api_gateway_resource" "gateway_resource_be" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_be.id
  parent_id   = aws_api_gateway_rest_api.rest_api_be.root_resource_id
  path_part   = "be"
}

resource "aws_api_gateway_method" "gateway_method_fe" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api_fe.id
  resource_id   = aws_api_gateway_resource.gateway_resource_fe.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "gateway_method_be" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api_be.id
  resource_id   = aws_api_gateway_resource.gateway_resource_be.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "gateway_integration_fe" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api_fe.id
  resource_id             = aws_api_gateway_resource.gateway_resource_fe.id
  http_method             = aws_api_gateway_method.gateway_method_fe.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_fe.invoke_arn
}
resource "aws_api_gateway_integration" "gateway_integration_be" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api_be.id
  resource_id             = aws_api_gateway_resource.gateway_resource_be.id
  http_method             = aws_api_gateway_method.gateway_method_be.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_be.invoke_arn
}

resource "aws_lambda_permission" "allow_apigw_fe_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fe.function_name
  principal     = "apigateway.amazonaws.com"

  # source_arn = "${aws_api_gateway_rest_api.rest_api_fe.execution_arn}/*/*"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.rest_api_fe.id}/*/${aws_api_gateway_method.gateway_method_fe.http_method}${aws_api_gateway_resource.gateway_resource_fe.path}"
}

resource "aws_lambda_permission" "allow_apigw_be_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_be.function_name
  principal     = "apigateway.amazonaws.com"

  # source_arn = "${aws_api_gateway_rest_api.rest_api_be.execution_arn}/*/*"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.rest_api_be.id}/*/${aws_api_gateway_method.gateway_method_be.http_method}${aws_api_gateway_resource.gateway_resource_be.path}"
}

resource "aws_api_gateway_deployment" "gateway_deployment_fe" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_fe.id

  depends_on = [
    aws_api_gateway_integration.gateway_integration_fe,
  ]
}

resource "aws_api_gateway_deployment" "gateway_deployment_be" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_be.id

  depends_on = [
    aws_api_gateway_integration.gateway_integration_fe,
  ]
}
