resource "aws_lambda_function" "api_lambda" {
  function_name = "devsecops-api-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.api_repo.repository_url}:latest"

  # On utilise x86_64 pour correspondre à la construction Docker standard
  architectures = ["arm64"]

  # IMPORTANT : Augmenter les ressources pour éviter les "Internal Server Error"
  # Un timeout de 3s est trop court pour un démarrage Node.js (Cold Start)
  timeout     = 30 
  memory_size = 512 

  # Configuration de l'environnement pour l'adapter Web
  environment {
    variables = {
      # On dit à l'adapter d'écouter sur le port 8080
      PORT = "8080"
      # Optionnel : On peut forcer l'adapter à logger plus de détails pour le debug
      AWS_LAMBDA_WEB_ADAPTER_LOG_LEVEL = "info"
    }
  }
}