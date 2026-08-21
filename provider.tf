terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  # Uncomment and configure a remote backend before using this in a team /
  # CI setting, so multiple pipeline runs share the same state file.
  #
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "lambda-file-processor/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "your-terraform-lock-table"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}
