terraform {
  required_version = ">= 1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # After running the bootstrap, uncomment this block to enable remote state
  # backend "s3" {
  #   bucket         = "c3ops-terraform-state-809704584374"
  #   key            = "preprod/terraform.tfstate"
  #   region         = "ap-south-2"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  allowed_account_ids = [var.allowed_account_id]

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}