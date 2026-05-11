resource "aws_lambda_function" "api_lambda" {
  function_name = "devsecops-api-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.api_repo.repository_url}:latest"

  architectures = ["x86_64"]

  timeout     = 30 
  memory_size = 512 

  environment {
    variables = {
      PORT = "8080"
      AWS_LAMBDA_WEB_ADAPTER_LOG_LEVEL = "info"
    }
  }
}