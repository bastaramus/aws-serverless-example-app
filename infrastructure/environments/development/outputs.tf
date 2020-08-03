output "s3_bucket_lambda_artifacts_arn" {
  description = "ARN of the S3 bucket with lambda artifacts"
  value       = module.s3.bucket_lambda_artifacts_arn
}

output "s3_bucket_media_content_arn" {
  description = "ARN of the S3 bucket with media content"
  value       = module.s3.bucket_media_content_arn
}

output "s3_bucket_lambda_artifacts_name" {
  description = "Name (id) of the S3 bucket with lambda artifacts"
  value       = module.s3.bucket_lambda_artifacts_name
}

output "s3_bucket_media_content" {
  description = "Name (id) of the S3 bucket with media content"
  value       = module.s3.bucket_media_content_name
}

output "s3_vpc_endpoint_id" {
  description = "Name (id) of the S3 VPC endpoint"
  value       = module.vpc.vpc_endpoint_s3_id
}

output "s3_vpc_endpoint_pl_id" {
  description = "The prefix list for the S3 VPC endpoint."
  value       = module.vpc.vpc_endpoint_s3_pl_id
}

output "xproject_lambda_default_sg_id" {
  description = "Default Security Group for Lambda functions."
  value       = aws_security_group.xproject_lambda_default_sg.id
}

output "public_subnets_id" {
  description = "IDs of the public subnets in the VPC."
  value       = module.vpc.public_subnets
}

output "intra_subnets_id" {
  description = "IDs of the intra subnets in the VPC."
  value       = module.vpc.intra_subnets
}

output "iam_policy_AWSLambdaNetworkInterfaces_arn" {
  description = "ARN of the policy AWSLambdaNetworkInterfaces"
  value       = aws_iam_policy.AWSLambdaNetworkInterfaces.arn
}