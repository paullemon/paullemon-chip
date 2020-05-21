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
resource "aws_route" "adm_usw1_adm_usw2-adm_usw1" {
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
resource "aws_route" "adm_usw1_adm_usw2-adm_usw2-public" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[2]
  destination_cidr_block    = var.vpc-adm_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}
resource "aws_route" "adm_usw1_adm_usw2-adm_usw2-private" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[3]
  destination_cidr_block    = var.vpc-adm_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}