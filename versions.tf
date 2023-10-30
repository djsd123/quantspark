terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    acl     = "private"
    bucket  = "kel-pulumi-inf-state"
    encrypt = "true"
    key     = "terraform/quantspark"
    region  = "eu-west-1"
  }

  required_version = ">= 1.6.2, < 2.0.0"
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Project   = "quantspark-tech-test"
      Terraform = "true"
    }
  }
}

provider "aws" {
  alias  = "aws-us-east-1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "quantspark-tech-test"
      Terraform = "true"
    }
  }
}
