data "aws_region" "current" {}
resource "aws_vpc" "main" {

  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "nodejs Application Primary VPC"
  }
}
locals {
  tags = {
    Environment = "${var.suffix}"
    CostCentre  = "CostCenter"
    Project     = "Terraform"
    Department  = "DevOps"

  }
}
resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "igw_main" },
    local.tags
  )
}
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    { Name = "main_rtb" },
    local.tags
  )
}
resource "aws_route_table_association" "Public_subnets_associations" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets, count.index).id
  route_table_id = aws_route_table.main.id
}
