provider "aws" {
  alias = var.region[0]
  region = var.region[0]
}
provider "aws" {
  alias = var.region[1]
  region = var.region[1]
}
provider "aws" {
  alias = var.region[2]
  region = var.region[2]
}

# Full mesh VPC peering for TFE VPCs
resource "aws_vpc_peering_connection" "tfe0_tfe1" {
  provider      = aws.var.region[0]
  vpc_id        = var.vpc-tfe0
  peer_vpc_id   = var.vpc-tfe1
  peer_region   = var.region[1]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "tfe0_tfe1" {
  provider                  = aws.var.region[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
  auto_accept               = true
}

# Full mesh VPC peering for Application VPCs
resource "aws_vpc_peering_connection" "app0_app1" {
  provider      = aws.var.region[0]
  vpc_id        = var.vpc-app0
  peer_vpc_id   = var.vpc-app1
  peer_region   = var.region[1]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "app0_app1" {
  provider                  = aws.var.region[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app1_app2" {
  provider      = aws.var.region[1]
  vpc_id        = var.vpc-app1
  peer_vpc_id   = var.vpc-app2
  peer_region   = var.region[2]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "app1_app2" {
  provider                  = aws.var.region[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.app1_app2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app0_app2" {
  provider      = aws.var.region[0]
  vpc_id        = var.vpc-app0
  peer_vpc_id   = var.vpc-app2
  peer_region   = var.region[2]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "app0_app2" {
  provider                  = aws.var.region[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app2.id
  auto_accept               = true
}

# Full mesh VPC peering for Admin VPCs
resource "aws_vpc_peering_connection" "adm0_adm1" {
  provider      = aws.var.region[0]
  vpc_id        = var.vpc-adm0
  peer_vpc_id   = var.vpc-adm1
  peer_region   = var.region[1]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "adm0_adm1" {
  provider                  = aws.var.region[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "adm1_adm2" {
  provider      = aws.var.region[1]
  vpc_id        = var.vpc-adm1
  peer_vpc_id   = var.vpc-adm2
  peer_region   = var.region[2]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "adm1_adm2" {
  provider                  = aws.var.region[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm1_adm2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "adm0_adm2" {
  provider      = aws.var.region[0]
  vpc_id        = var.vpc-adm0
  peer_vpc_id   = var.vpc-adm2
  peer_region   = var.region[2]
  auto_accept   = false
}
resource "aws_vpc_peering_connection_accepter" "adm0_adm2" {
  provider                  = aws.var.region[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm2.id
  auto_accept               = true
}