resource "random_id" "lambda_artifacts_bucket" {
  byte_length = 2
}

resource "aws_s3_bucket" "lambda_artifacts_bucket" {
  bucket        = "${var.lambda_artifacts_bucket_name}-${random_id.lambda_artifacts_bucket.dec}"
  acl           = "private"

  tags = var.lambda_artifacts_tags

}

resource "aws_s3_bucket" "media_content_bucket" {
  bucket        = "${var.media_content_bucket_name}-${random_id.lambda_artifacts_bucket.dec}"
  acl           = "private"

  tags = var.media_content_tags
}
