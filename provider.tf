terraform {
  required_version = ">= 1.9.5"

  # ADD THIS SECTION BELOW
  backend "s3" {
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
  region              = "ap-south-2"
  allowed_account_ids = ["809704584374"]
  
  default_tags {
    tags = {
      Project     = "c3ops_preprod"
      Environment = "PreProd"
      ManagedBy   = "Terraform"
    }
  }
}