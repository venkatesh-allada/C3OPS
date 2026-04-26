locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = ["ap-south-2a", "ap-south-2b"]
  
  subnets = {
    public  = ["10.0.1.0/24", "10.0.2.0/24"]
    web     = ["10.0.11.0/24", "10.0.12.0/24"]
    app     = ["10.0.21.0/24", "10.0.22.0/24"]
    db      = ["10.0.31.0/24", "10.0.32.0/24"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "c3ops_preprod-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "c3ops_preprod-igw" }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "c3ops_preprod-nat-eip" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # References public subnet in subnets.tf
  tags          = { Name = "c3ops_preprod-nat" }
  depends_on    = [aws_internet_gateway.igw]
}