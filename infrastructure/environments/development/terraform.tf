terraform {
  required_version = "~> 0.12.28"

  backend "s3" {
    bucket               = "xproject-tfstate-storage-v1"
    dynamodb_table       = "XProject-tf-lock-table"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    workspace_key_prefix = "cors"
  }
}