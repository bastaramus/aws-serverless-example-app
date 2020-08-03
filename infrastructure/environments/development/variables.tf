variable "aws_region" {}
variable "environment" {}
data "aws_availability_zones" "available" {}

variable "lambda_artifacts_bucket_name" {}
variable "media_content_bucket_name" {}

