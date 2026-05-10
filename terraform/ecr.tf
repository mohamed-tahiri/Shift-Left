resource "aws_ecr_repository" "api_repo" {
  name                 = "devsecops-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Double sécurité : scan natif AWS au push de l'image
  }
}