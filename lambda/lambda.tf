resource "aws_lambda_function" "lambda_fe" {
  function_name = var.function_fe

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.s3_object_fe.key

  runtime = "nodejs16.x"
  handler = "handler.handler"

  # vpc_config {
  #   subnet_ids         = [aws_subnet.subnet_fe.id]
  #   security_group_ids = [aws_security_group.security_group.id]
  # }

  source_code_hash = data.archive_file.source_fe.output_base64sha256

  role = aws_iam_role.lambda_role.arn
}

resource "aws_lambda_function" "lambda_be" {
  function_name = var.function_be

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.s3_object_be.key

  runtime = "nodejs16.x"
  handler = "handler.handler"

  # vpc_config {
  #   subnet_ids         = [aws_subnet.subnet_be.id]
  #   security_group_ids = [aws_security_group.security_group.id]
  # }
  source_code_hash = data.archive_file.source_be.output_base64sha256

  role = aws_iam_role.lambda_role.arn
}

