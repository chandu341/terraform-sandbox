
resource "aws_s3_bucket" "app_artifacts" {
  bucket_prefix = "ecommerce-app-artifacts-"

  tags = {
    Name = "${var.project_name}-app-artifacts"
  }
}

resource "aws_s3_bucket_public_access_block" "app_artifacts" {
  bucket = aws_s3_bucket.app_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_artifacts" {
  bucket = aws_s3_bucket.app_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "app" {
  bucket = aws_s3_bucket.app_artifacts.id
  key    = "release/app.py"

  source      = "${path.module}/application/app.py"
  source_hash = filemd5("${path.module}/application/app.py")

  depends_on = [
    aws_s3_bucket_public_access_block.app_artifacts
  ]
}

resource "aws_s3_object" "requirements" {
  bucket = aws_s3_bucket.app_artifacts.id
  key    = "release/requirements.txt"

  source      = "${path.module}/application/requirements.txt"
  source_hash = filemd5("${path.module}/application/requirements.txt")

  depends_on = [
    aws_s3_bucket_public_access_block.app_artifacts
  ]
}
