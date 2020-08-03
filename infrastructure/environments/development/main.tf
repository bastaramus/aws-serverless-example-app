module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "xproject-vpc"
  cidr = "10.20.0.0/16"

  azs             = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  intra_subnets = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
  public_subnets  = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  
  enable_s3_endpoint = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_suffix = "public"
  public_subnet_tags = {
    Type = "public"
  }

  intra_subnet_suffix = "intra"
  intra_subnet_tags = {
    Type = "intra"
  }


  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}
###
#------------ S3 configurations ------------ 
###

module "s3" {
  source = "../../modules/s3"

  #Bucket name must bee unique, so the final bucket name will looks like ${var.bucket_name}-${random_id}
  
  # S3 for lambda artiacts
  lambda_artifacts_bucket_name = var.lambda_artifacts_bucket_name
  lambda_artifacts_tags = {
    Terraform   = "true"
    Environment = var.environment
    Name = "XProject Lambda Artifacts ${var.environment} env"
  }

  # S3 for media content
  media_content_bucket_name = var.media_content_bucket_name
  media_content_tags = {
    Terraform   = "true"
    Environment = var.environment
    Name = "XProject Media Content ${var.environment} env"
  }
}

###
#------------ Security Groups ------------ 
###

# Security group for lambda function
resource "aws_security_group" "xproject_lambda_default_sg" {
  name        = "xproject_lambda_sg"
  description = "Used for xproject lambda functions as default sg"
  vpc_id      = module.vpc.vpc_id
  
  #Access to s3 endpoint
  egress {
    prefix_list_ids = ["${module.vpc.vpc_endpoint_s3_pl_id}"]
    from_port       = 0
    to_port         = 0
    protocol    = "-1"
  }
}

###
#------------ IAM ------------ 
###

# Policy to run Lambda in a VPC
resource "aws_iam_policy" "AWSLambdaNetworkInterfaces" {
  name        = "AWSLambdaNetworkInterfaces"
  description = "Policy to run Lambda in a VPC"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}