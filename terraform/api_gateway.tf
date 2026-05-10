resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "devsecops-gateway"
  protocol_type = "HTTP"
  target        = aws_lambda_function.api_lambda.arn
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}

output "base_url" {
  value = aws_apigatewayv2_api.lambda_api.api_endpoint
}