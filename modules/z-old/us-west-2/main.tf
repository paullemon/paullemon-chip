provider "aws" {
  region = var.region
}
data "aws_availability_zones" "azs" {
  state = "available"
}

##TFE##
resource "aws_vpc" "vpc-tfe" {
  cidr_block           = "172.22.0.0/22"
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project} TFE VPC"
    Project = var.project
    Owner   = var.owner
  }
}
resource "aws_subnet" "sub-tfe" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-tfe.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-tfe.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name    = "${var.project} TFE Subnet ${count.index}"
    Project = var.project
    Owner   = var.owner
  }
}
##APP##
resource "aws_vpc" "vpc-app" {
  cidr_block           = "172.22.4.0/22"
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project} Application VPC"
    Project = var.project
    Owner   = var.owner
  }
}
resource "aws_subnet" "sub-app" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-app.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-app.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name    = "${var.project} Application Subnet ${count.index}"
    Project = var.project
    Owner   = var.owner
  }
}
##ADM##
resource "aws_vpc" "vpc-adm" {
  cidr_block           = "172.22.8.0/22"
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project} Admin VPC"
    Project = var.project
    Owner   = var.owner
  }
}
resource "aws_subnet" "sub-adm" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-adm.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-adm.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name    = "${var.project} Admin Subnet ${count.index}"
    Project = var.project
    Owner   = var.owner
  }
}