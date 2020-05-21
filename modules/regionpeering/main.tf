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
  provider                  = aws.usw1
  for_each = ["public", "private"]
  route_table_id            = var.vpc-adm_usw1[for_each.index + 2]
  destination_cidr_block    = var.vpc-adm_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}
resource "aws_vpc_peering_connection_accepter" "adm_usw1_adm_usw2" {
  provider                  = aws.usw2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
  auto_accept               = true
}
resource "aws_route" "adm_usw1_adm_usw2-adm_usw2" {
  provider                  = aws.usw2
  for_each = ["public", "private"]
  route_table_id            = var.vpc-adm_usw2[for_each.index + 2]
  destination_cidr_block    = var.vpc-adm_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}