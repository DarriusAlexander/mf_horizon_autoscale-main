output "s3_bucket_id" {
  value       = aws_s3_bucket.bucket.id
  description = "the bucket Id that get's assigned to it once it's created."
}
