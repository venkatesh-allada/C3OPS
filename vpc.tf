locals {
  # These pull from your variables.tf / terraform.tfvars
  vpc_cidr = var.vpc_cidr
  azs      = var.availability_zones

  # Professional approach: Calculate subnets dynamically 
  # This divides your /16 into /24 chunks automatically
  subnets = {
    public = [cidrsubnet(local.vpc_cidr, 8, 1), cidrsubnet(local.vpc_cidr, 8, 2)]
    web    = [cidrsubnet(local.vpc_cidr, 8, 11), cidrsubnet(local.vpc_cidr, 8, 12)]
    app    = [cidrsubnet(local.vpc_cidr, 8, 21), cidrsubnet(local.vpc_cidr, 8, 22)]
    db     = [cidrsubnet(local.vpc_cidr, 8, 31), cidrsubnet(local.vpc_cidr, 8, 32)]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Using dynamic naming: e.g., c3ops-preprod-vpc
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id

  # This grabs the first public subnet created in subnets.tf
  subnet_id = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat"
  }

  # Good practice: NAT needs the IGW to exist first to talk to the internet
  depends_on = [aws_internet_gateway.igw]
}