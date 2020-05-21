provider "aws" {
  alias  = "usw1"
  region = "us-west-1"
}
provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}
provider "aws" {
  alias  = "euc1"
  region = "eu-central-1"
}

variable "rtb_names" {
  default = ["public", "private"]
}
################################################
# Vpc peering for Admin VPCs
################################################
# usw1 to usw2
resource "aws_vpc_peering_connection" "adm_usw1_adm_usw2" {
  provider    = aws.usw1
  vpc_id      = var.vpc-adm_usw1[0]
  peer_vpc_id = var.vpc-adm_usw2[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "adm_usw1 to adm_usw2 Peering"
    )
  )
}
resource "aws_route" "adm_usw1_adm_usw2-peer" {
  count                     = length(var.rtb_names)
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[count.index + 2]
  destination_cidr_block    = var.vpc-adm_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}
resource "aws_vpc_peering_connection_accepter" "adm_usw1_adm_usw2" {
  provider                  = aws.usw2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
  auto_accept               = true
}
resource "aws_route" "adm_usw1_adm_usw2-accepter" {
  count                     = length(var.rtb_names)
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[count.index + 2]
  destination_cidr_block    = var.vpc-adm_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}
# usw1 to euc1
resource "aws_vpc_peering_connection" "adm_usw1_adm_euc1" {
  provider    = aws.usw1
  vpc_id      = var.vpc-adm_usw1[0]
  peer_vpc_id = var.vpc-adm_euc1[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "adm_usw1 to adm_euc1 Peering"
    )
  )
}
resource "aws_route" "adm_usw1_adm_euc1-peer" {
  count                     = length(var.rtb_names)
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[count.index + 2]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
}
resource "aws_vpc_peering_connection_accepter" "adm_usw1_adm_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
  auto_accept               = true
}
resource "aws_route" "adm_usw1_adm_euc1-accepter" {
  count                     = length(var.rtb_names)
  provider                  = aws.euc1
  route_table_id            = var.vpc-adm_euc1[count.index + 2]
  destination_cidr_block    = var.vpc-adm_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
}
# usw2 to euc1
resource "aws_vpc_peering_connection" "adm_usw2_adm_euc1" {
  provider    = aws.usw2
  vpc_id      = var.vpc-adm_usw2[0]
  peer_vpc_id = var.vpc-adm_euc1[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "adm_usw2 to adm_euc1 Peering"
    )
  )
}
resource "aws_route" "adm_usw2_adm_euc1-peer" {
  count                     = length(var.rtb_names)
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[count.index + 2]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
}
resource "aws_vpc_peering_connection_accepter" "adm_usw2_adm_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
  auto_accept               = true
}
resource "aws_route" "adm_usw2_adm_euc1-accepter" {
  count                     = length(var.rtb_names)
  provider                  = aws.euc1
  route_table_id            = var.vpc-adm_euc1[count.index + 2]
  destination_cidr_block    = var.vpc-adm_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
}