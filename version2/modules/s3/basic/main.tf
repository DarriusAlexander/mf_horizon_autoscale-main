#-----------------------------
# Module : s3_Bucket
#-----------------------------
# path: /s3/basic/main.tf
#-----------------------------

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}

resource "aws_s3_object" "upload_files" {
  bucket   = aws_s3_bucket.bucket.id
  for_each = fileset("${var.fileset}", "**")
  key      = each.value
  source   = "./${var.fileset}/${each.value}"
  etag     = filemd5("./${var.fileset}/${each.value}")
}

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.status == "Enabled" ? var.status : ""
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_default" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "oc" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.oc]
  bucket     = aws_s3_bucket.bucket.id
  acl        = var.acl

}
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

