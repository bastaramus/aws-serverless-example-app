output "bucket_lambda_artifacts_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.lambda_artifacts_bucket.arn
}

output "bucket_lambda_artifacts_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.lambda_artifacts_bucket.id
}

output "bucket_media_content_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.media_content_bucket.arn
}

output "bucket_media_content_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.media_content_bucket.id
}

