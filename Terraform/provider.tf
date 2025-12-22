terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = "ap-northeast-2"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias = "tokyo"
  region = "ap-northeast-1"
}