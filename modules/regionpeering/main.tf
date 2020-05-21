provider "aws" {
  alias  = "0"
  region = "us-west-1"
}
provider "aws" {
  alias  = "1"
  region = "us-west-2"
}
provider "aws" {
  alias  = "2"
  region = "eu-central-1"
}

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.0" (us-west-1)         #
########################################
resource "aws_vpc_peering_connection" "adm0_adm1" {
  provider    = aws.0
  vpc_id      = var.vpc-adm0[0]
  peer_vpc_id = var.vpc-adm1[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM0 to ADM1 Peering"
    )
  )
}
resource "aws_vpc_peering_connection" "adm0_adm2" {
  provider    = aws.0
  vpc_id      = var.vpc-adm0[0]
  peer_vpc_id = var.vpc-adm2[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM0 to ADM21 Peering"
    )
  )
}

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.1" (us-west-2)         #
########################################
resource "aws_vpc_peering_connection" "adm1_adm2" {
  provider    = aws.1
  vpc_id      = var.vpc-adm1[0]
  peer_vpc_id = var.vpc-adm2[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM1 to ADM2 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "adm0_adm1" {
  provider                  = aws.1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm1.id
  auto_accept               = true
}

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.2" (eu-central-1)      #
########################################
resource "aws_vpc_peering_connection_accepter" "adm0_adm2" {
  provider                  = aws.2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection_accepter" "adm1_adm2" {
  provider                  = aws.2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm1_adm2.id
  auto_accept               = true
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.0" (us-west-1)               #
##############################################
resource "aws_vpc_peering_connection" "app0_app1" {
  provider    = aws.0
  vpc_id      = var.vpc-app0[0]
  peer_vpc_id = var.vpc-app1[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP0 to APP1 Peering"
    )
  )
}
resource "aws_vpc_peering_connection" "app0_app2" {
  provider    = aws.0
  vpc_id      = var.vpc-app0[0]
  peer_vpc_id = var.vpc-app2[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP0 to APP2 Peering"
    )
  )
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.1" (us-west-2)               #
##############################################
resource "aws_vpc_peering_connection_accepter" "app0_app1" {
  provider                  = aws.1
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app1_app2" {
  provider    = aws.1
  vpc_id      = var.vpc-app1[0]
  peer_vpc_id = var.vpc-app2[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP1 to APP2 Peering"
    )
  )
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.2" (eu-central-1)            #
##############################################
resource "aws_vpc_peering_connection_accepter" "app0_app2" {
  provider                  = aws.2
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app2.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "app1_app2" {
  provider                  = aws.2
  vpc_peering_connection_id = aws_vpc_peering_connection.app1_app2.id
  auto_accept               = true
}

######################################
# Full mesh VPC peering for TFE VPCs #
# Provider "aws.0" (us-west-1)       #
######################################
resource "aws_vpc_peering_connection" "tfe0_tfe1" {
  provider    = aws.0
  vpc_id      = var.vpc-tfe0[0]
  peer_vpc_id = var.vpc-tfe1[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "TFE0 to TFE1 Peering"
    )
  )
}
resource "aws_route" "tfe0_tfe1-tfe0-public" {
  provider                  = aws.0
  route_table_id            = var.vpc-tfe0[2]
  destination_cidr_block    = var.vpc-tfe1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
}
resource "aws_route" "tfe0_tfe1-tfe0-private" {
  provider                  = aws.0
  route_table_id            = var.vpc-tfe0[3]
  destination_cidr_block    = var.vpc-tfe1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
}

######################################
# Full mesh VPC peering for TFE VPCs #
# Provider "aws.1" (us-west-2)       #
######################################
resource "aws_vpc_peering_connection_accepter" "tfe0_tfe1" {
  provider                  = aws.1
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
  auto_accept               = true
}
resource "aws_route" "tfe0_tfe1-tfe1-public" {
  provider                  = aws.1
  route_table_id            = var.vpc-tfe1[2]
  destination_cidr_block    = var.vpc-tfe0[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
}
resource "aws_route" "tfe0_tfe1-tfe1-private" {
  provider                  = aws.1
  route_table_id            = var.vpc-tfe1[3]
  destination_cidr_block    = var.vpc-tfe0[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
}
