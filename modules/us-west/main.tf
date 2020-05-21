provider "aws" {
  region = var.region
}
data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  cidr_2oct            = var.region == "us-west-1" ? 21 : 22
  cidr                 = "172.${local.cidr_2oct}.0.0/19"
  cidr_vpc-tfe         = cidrsubnet(local.cidr, 2, 0)
  cidr_vpc-tfe_public  = cidrsubnet(local.cidr_vpc-tfe, 1, 0)
  cidr_vpc-tfe_private = cidrsubnet(local.cidr_vpc-tfe, 1, 1)
  cidr_vpc-app         = cidrsubnet(local.cidr, 2, 1)
  cidr_vpc-app_public  = cidrsubnet(local.cidr_vpc-app, 1, 0)
  cidr_vpc-app_private = cidrsubnet(local.cidr_vpc-app, 1, 1)
  cidr_vpc-adm         = cidrsubnet(local.cidr, 2, 2)
  cidr_vpc-adm_public  = cidrsubnet(local.cidr_vpc-adm, 1, 0)
  cidr_vpc-adm_private = cidrsubnet(local.cidr_vpc-adm, 1, 1)
}

##TFE##
resource "aws_vpc" "vpc-tfe" {
  cidr_block           = local.cidr_vpc-tfe
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - VPC"
    )
  )
}
resource "aws_internet_gateway" "igw-tfe" {
  vpc_id = aws_vpc.vpc-tfe.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Internet Gateway"
    )
  )
}
resource "aws_subnet" "sub-tfe_public" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-tfe.id
  cidr_block              = cidrsubnet(local.cidr_vpc-tfe_public, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Public Subnet ${count.index + 1}"
    )
  )
}
resource "aws_subnet" "sub-tfe_private" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-tfe.id
  cidr_block              = cidrsubnet(local.cidr_vpc-tfe_private, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Private Subnet ${count.index + 1}"
    )
  )
}
resource "aws_route_table" "rtb-tfe_public" {
  vpc_id = aws_vpc.vpc-tfe.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tfe.id
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Public Route Table"
    )
  )
}
resource "aws_default_route_table" "rtb-tfe_private" {
  default_route_table_id = aws_vpc.vpc-tfe.default_route_table_id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Private Route Table"
    )
  )
}
resource "aws_route_table_association" "rtb-tfe_public" {
  count          = length(data.aws_availability_zones.azs.zone_ids)
  subnet_id      = element(aws_subnet.sub-tfe_public.*.id, count.index)
  route_table_id = aws_route_table.rtb-tfe_public.id
}
resource "aws_route_table_association" "rtb-tfe_private" {
  count          = length(data.aws_availability_zones.azs.zone_ids)
  subnet_id      = element(aws_subnet.sub-tfe_private.*.id, count.index)
  route_table_id = aws_default_route_table.rtb-tfe_private.id
}
resource "aws_default_security_group" "sg-tfe" {
  vpc_id = aws_vpc.vpc-tfe.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Default SG"
    )
  )
}
resource "aws_default_network_acl" "nacl-tfe" {
  default_network_acl_id = aws_vpc.vpc-tfe.default_network_acl_id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = concat(tolist(aws_subnet.sub-tfe_public.*.id), tolist(aws_subnet.sub-tfe_private.*.id))
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - Default NACL"
    )
  )
}
resource "aws_network_acl" "nacl-tfe_public" {
  vpc_id = aws_vpc.vpc-tfe.id
  ingress {
    protocol   = 6
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = 6
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8800
    to_port    = 8800
  }
  ingress {
    protocol   = -1
    rule_no    = 500
    action     = "allow"
    cidr_block = "10.0.0.0/8"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = -1
    rule_no    = 501
    action     = "allow"
    cidr_block = "172.16.0.0/12"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = -1
    rule_no    = 502
    action     = "allow"
    cidr_block = "192.168.0.0/16"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = 6
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = -1
    rule_no    = 500
    action     = "allow"
    cidr_block = "10.0.0.0/8"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 501
    action     = "allow"
    cidr_block = "172.16.0.0/12"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 502
    action     = "allow"
    cidr_block = "192.168.0.0/16"
    from_port  = 0
    to_port    = 0
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - TFE - TEST NACL"
    )
  )
}

##APP##
resource "aws_vpc" "vpc-app" {
  cidr_block           = local.cidr_vpc-app
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - VPC"
    )
  )
}
resource "aws_internet_gateway" "igw-app" {
  vpc_id = aws_vpc.vpc-app.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Internet Gateway"
    )
  )
}
resource "aws_subnet" "sub-app_public" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-app.id
  cidr_block              = cidrsubnet(local.cidr_vpc-app_public, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Public Subnet ${count.index + 1}"
    )
  )
}
resource "aws_subnet" "sub-app_private" {
  count                   = length(data.aws_availability_zones.azs.zone_ids)
  vpc_id                  = aws_vpc.vpc-app.id
  cidr_block              = cidrsubnet(local.cidr_vpc-app_private, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Private Subnet ${count.index + 1}"
    )
  )
}
resource "aws_route_table" "rtb-app_public" {
  vpc_id = aws_vpc.vpc-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-app.id
  }
  route {
    cidr_block                = aws_vpc.vpc-adm.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.app-adm.id
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Public Route Table"
    )
  )
}
resource "aws_default_route_table" "rtb-app_private" {
  default_route_table_id = aws_vpc.vpc-app.default_route_table_id
  route {
    cidr_block                = aws_vpc.vpc-adm.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.app-adm.id
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Private Route Table"
    )
  )
}
resource "aws_route_table_association" "rtb-app_public" {
  count          = length(data.aws_availability_zones.azs.zone_ids)
  subnet_id      = element(aws_subnet.sub-app_public.*.id, count.index)
  route_table_id = aws_route_table.rtb-app_public.id
}
resource "aws_route_table_association" "rtb-app_private" {
  count          = length(data.aws_availability_zones.azs.zone_ids)
  subnet_id      = element(aws_subnet.sub-app_private.*.id, count.index)
  route_table_id = aws_default_route_table.rtb-app_private.id
}
resource "aws_default_security_group" "sg-app" {
  vpc_id = aws_vpc.vpc-app.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Default SG"
    )
  )
}
resource "aws_default_network_acl" "nacl-app" {
  default_network_acl_id = aws_vpc.vpc-app.default_network_acl_id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = concat(tolist(aws_subnet.sub-app_public.*.id), tolist(aws_subnet.sub-app_private.*.id))
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Default NACL"
    )
  )
}

##ADM##
resource "aws_vpc" "vpc-adm" {
  cidr_block           = local.cidr_vpc-adm
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - VPC"
    )
  )
}
resource "aws_internet_gateway" "igw-adm" {
  vpc_id = aws_vpc.vpc-adm.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Internet Gateway"
    )
  )
}
resource "aws_subnet" "sub-adm_public" {
  #count = length(data.aws_availability_zones.azs.zone_ids)
  count                   = 2
  vpc_id                  = aws_vpc.vpc-adm.id
  cidr_block              = cidrsubnet(local.cidr_vpc-adm_public, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Public Subnet ${count.index + 1}"
    )
  )
}
resource "aws_subnet" "sub-adm_private" {
  #count = length(data.aws_availability_zones.azs.zone_ids)
  count                   = 2
  vpc_id                  = aws_vpc.vpc-adm.id
  cidr_block              = cidrsubnet(local.cidr_vpc-adm_private, 2, count.index)
  availability_zone       = tolist(data.aws_availability_zones.azs.names)[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Private Subnet ${count.index + 1}"
    )
  )
}
resource "aws_route_table" "rtb-adm_public" {
  vpc_id = aws_vpc.vpc-adm.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-adm.id
  }
  route {
    cidr_block                = aws_vpc.vpc-app.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.app-adm.id
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Public Route Table"
    )
  )
}
resource "aws_default_route_table" "rtb-adm_private" {
  default_route_table_id = aws_vpc.vpc-adm.default_route_table_id
  route {
    cidr_block                = aws_vpc.vpc-app.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.app-adm.id
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Private Route Table"
    )
  )
}
resource "aws_route_table_association" "rtb-adm_public" {
  #count = length(data.aws_availability_zones.azs.zone_ids)
  count          = 2
  subnet_id      = element(aws_subnet.sub-adm_public.*.id, count.index)
  route_table_id = aws_route_table.rtb-adm_public.id
}
resource "aws_route_table_association" "rtb-adm_private" {
  #count = length(data.aws_availability_zones.azs.zone_ids)
  count          = 2
  subnet_id      = element(aws_subnet.sub-adm_private.*.id, count.index)
  route_table_id = aws_default_route_table.rtb-adm_private.id
}
resource "aws_default_security_group" "sg-adm" {
  vpc_id = aws_vpc.vpc-adm.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Default SG"
    )
  )
}
resource "aws_default_network_acl" "nacl-adm" {
  default_network_acl_id = aws_vpc.vpc-adm.default_network_acl_id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = concat(tolist(aws_subnet.sub-adm_public.*.id), tolist(aws_subnet.sub-adm_private.*.id))
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Admin - Default NACL"
    )
  )
}

##Peering
resource "aws_vpc_peering_connection" "app-adm" {
  peer_vpc_id = aws_vpc.vpc-adm.id
  vpc_id      = aws_vpc.vpc-app.id
  auto_accept = true
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP to ADM Peering"
    )
  )
}