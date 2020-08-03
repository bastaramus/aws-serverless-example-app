/****************************************
*************** INIT ********************
*****************************************/

/****************************************
DO NOT RUN THIS IF YOU ARE NOT SURE!
This config is a big bang step.

It will create the lock table in DynamoDB
and the S3 bucket for storing the current
Terraform state for all other modules. 

****************************************/

resource "aws_dynamodb_table" "XProject_tf_lock_table" {
  name			= "XProject-tf-lock-table"
  read_capacity		= 20
  write_capacity	= 20
  hash_key		= "LockID"

  attribute {
    name		= "LockID"
    type		= "S"
  }

  tags = {
    Name = "XProject DynamoDB Terraform State Lock Table"
    Cost-Center         = "ops"
  }
}

resource "aws_s3_bucket" "XProject-tfstate-storage-v1" {
  acl			= "private"
  bucket		= "xproject-tfstate-storage-v1"

  versioning {
    enabled		= true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "XProject S3 Remote Terraform State Store"   
    Cost-Center         = "ops"
  }
}