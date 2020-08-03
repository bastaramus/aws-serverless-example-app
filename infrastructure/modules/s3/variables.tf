variable "lambda_artifacts_bucket_name" {
  description = "Name of the s3 bucket."
  type = string
}

variable "lambda_artifacts_tags" {
  description = "Tags to set on the bucket."
  type = map(string)
  default = {}
}

variable "media_content_bucket_name" {
  description = "Name of the s3 bucket."
  type = string
}

variable "media_content_tags" {
  description = "Tags to set on the bucket."
  type = map(string)
  default = {}
}