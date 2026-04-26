terraform {
  required_version = ">= 1.9.5"

  backend "s3" {
    # This block must remain hardcoded or use a partial configuration file
    bucket         = "c3ops-terraform-state-809704584374"
    key            = "preprod/core-infra/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.allowed_account_id]

  # These tags will be applied to EVERY resource created in this project automatically
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}