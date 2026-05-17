terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "devsecops-terraform-state-768669379117"
    key            = "devsecops-project/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "devsecops-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-3"
}

