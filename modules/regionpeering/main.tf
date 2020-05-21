provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# Full mesh VPC peering for TFE VPCs
resource "aws_vpc_peering_connection" "tfe0_tfe1" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc-tfe0
  peer_vpc_id = var.vpc-tfe1
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "TFE0 to TFE1 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "tfe0_tfe1" {
  provider                  = aws.us-west-2
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe0_tfe1.id
  auto_accept               = true
}

# Full mesh VPC peering for Application VPCs
resource "aws_vpc_peering_connection" "app0_app1" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc-app0
  peer_vpc_id = var.vpc-app1
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP0 to APP1 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "app0_app1" {
  provider                  = aws.us-west-2
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app0_app2" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc-app0
  peer_vpc_id = var.vpc-app2
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP0 to APP2 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "app0_app2" {
  provider                  = aws.eu-central-1
  vpc_peering_connection_id = aws_vpc_peering_connection.app0_app2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app1_app2" {
  provider    = aws.us-west-2
  vpc_id      = var.vpc-app1
  peer_vpc_id = var.vpc-app2
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "APP1 to APP2 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "app1_app2" {
  provider                  = aws.eu-central-1
  vpc_peering_connection_id = aws_vpc_peering_connection.app1_app2.id
  auto_accept               = true
}

# Full mesh VPC peering for Admin VPCs
resource "aws_vpc_peering_connection" "adm0_adm1" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc-adm0
  peer_vpc_id = var.vpc-adm1
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM0 to ADM1 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "adm0_adm1" {
  provider                  = aws.us-west-2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "adm0_adm2" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc-adm0
  peer_vpc_id = var.vpc-adm2
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM0 to ADM21 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "adm0_adm2" {
  provider                  = aws.eu-central-1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm0_adm2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "adm1_adm2" {
  provider    = aws.us-west-2
  vpc_id      = var.vpc-adm1
  peer_vpc_id = var.vpc-adm2
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "ADM1 to ADM2 Peering"
    )
  )
}
resource "aws_vpc_peering_connection_accepter" "adm1_adm2" {
  provider                  = aws.eu-central-1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm1_adm2.id
  auto_accept               = true
}
