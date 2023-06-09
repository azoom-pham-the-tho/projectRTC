resource "aws_lambda_permission" "logging_fe" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fe.function_name
  principal     = "logs.us-east-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.log_group_fe.arn}:*"
}
resource "aws_cloudwatch_log_group" "log_group_fe" {
  name = "/rtc_fe"
  retention_in_days = 30
}
resource "aws_lambda_permission" "logging_be" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_be.function_name
  principal     = "logs.us-east-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.log_group_be.arn}:*"
}
resource "aws_cloudwatch_log_group" "log_group_be" {
  name = "/rtc_be"
  retention_in_days = 30
}
