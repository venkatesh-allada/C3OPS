variable "aws_region" {
  description = "Target AWS Region"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment Name (dev/preprod/prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "Main VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of target availability zones"
  type        = list(string)
}

variable "allowed_account_id" {
  description = "The AWS Account ID to prevent deployment to the wrong account"
  type        = string
}