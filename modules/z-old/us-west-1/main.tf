provider "aws" {
  region = var.region
}
data "aws_availability_zones" "azs" {
  state = "available"
}

##TFE##
resource "aws_vpc" "vpc-tfe" {
  cidr_block           = "172.21.0.0/22"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} TFE VPC"
    )
  )
}
resource "aws_subnet" "sub-tfe" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-tfe.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-tfe.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} TFE Subnet ${count.index + 1}"
    )
  )
}
##APP##
resource "aws_vpc" "vpc-app" {
  cidr_block           = "172.21.4.0/22"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} Application VPC"
    )
  )
}
resource "aws_subnet" "sub-app" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-app.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-app.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} Application Subnet ${count.index + 1}"
    )
  )
}
##ADM##
resource "aws_vpc" "vpc-adm" {
  cidr_block           = "172.21.8.0/22"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} Admin VPC"
    )
  )
}
resource "aws_subnet" "sub-adm" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-adm.id
  cidr_block              = cidrsubnet(aws_vpc.vpc-adm.cidr_block, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.project} Admin Subnet ${count.index + 1}"
    )
  )
}