# resource "aws_s3_bucket" "terraform_state" {
#     bucket = "devsecops-terraform-state-768669379117" 
    
#     lifecycle {
#         prevent_destroy = true 
#     }
# }

# resource "aws_s3_bucket_versioning" "enabled" {
#     bucket = aws_s3_bucket.terraform_state.id
    
#     versioning_configuration {
#         status = "Enabled"
#     }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
#     bucket = aws_s3_bucket.terraform_state.id
#     rule {
#         apply_server_side_encryption_by_default {
#             sse_algorithm     = "aws:kms" # Utilisation de KMS
#         }
#     }
# }

# resource "aws_s3_bucket_public_access_block" "public_block" {
#     bucket                  = aws_s3_bucket.terraform_state.id
#     block_public_acls       = true
#     block_public_policy     = true
#     ignore_public_acls      = true
#     restrict_public_buckets = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#     name         = "devsecops-terraform-locks"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key     = "LockID"

#     attribute {
#         name = "LockID"
#         type = "S"
#     }
#     point_in_time_recovery {
#         enabled = true
#     }

#     server_side_encryption {
#         enabled     = true
#         kms_key_arn = "arn:aws:kms:eu-west-3:768669379117:alias/aws/dynamodb" # Clé managée par défaut
#     }

# }
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "devsecops-terraform-state-${data.aws_caller_identity.current.account_id}" # ✅ Plus d'ID hardcodé

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state.arn # ✅ CMK dédiée au lieu de la clé par défaut
    }
    bucket_key_enabled = true # ✅ Réduit les appels KMS (coûts)
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "terraform_state" { # ✅ CMK dédiée (remplace alias/aws/dynamodb partagé)
  description             = "CMK pour le state Terraform devsecops"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/devsecops-terraform-state"
  target_key_id = aws_kms_key.terraform_state.key_id
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "devsecops-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.terraform_state.arn # ✅ Référence dynamique, plus d'ARN hardcodé
  }
}
