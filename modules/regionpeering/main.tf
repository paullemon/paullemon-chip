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

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.usw1" (us-west-1)      #
########################################
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
resource "aws_route" "adm_usw1_adm_usw2-adm_usw1-public" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[2]
  destination_cidr_block    = var.vpc-adm_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}
resource "aws_route" "adm_usw1_adm_usw2-adm_usw1-private" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[3]
  destination_cidr_block    = var.vpc-adm_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
}

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
resource "aws_route" "adm_usw1_adm_euc1-adm_usw1-public" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[2]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
}
resource "aws_route" "adm_usw1_adm_euc1-adm_usw1-private" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-adm_usw1[3]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
}

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.usw2" (us-west-2)      #
########################################
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
resource "aws_route" "adm_usw2_adm_euc1-adm_usw1-public" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[2]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
}
resource "aws_route" "adm_usw2_adm_euc1-adm_usw1-private" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-adm_usw2[3]
  destination_cidr_block    = var.vpc-adm_euc1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
}


resource "aws_vpc_peering_connection_accepter" "adm_usw1_adm_usw2" {
  provider                  = aws.usw2
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_usw2.id
  auto_accept               = true
}

########################################
# Full mesh VPC peering for Admin VPCs #
# Provider "aws.euc1" (eu-central-1)   #
########################################
resource "aws_vpc_peering_connection_accepter" "adm_usw1_adm_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw1_adm_euc1.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection_accepter" "adm_usw2_adm_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.adm_usw2_adm_euc1.id
  auto_accept               = true
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.usw1" (us-west-1)            #
##############################################
resource "aws_vpc_peering_connection" "app_usw1_app_usw2" {
  provider    = aws.usw1
  vpc_id      = var.vpc-app_usw1[0]
  peer_vpc_id = var.vpc-app_usw2[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "app_usw1 to app_usw2 Peering"
    )
  )
}
resource "aws_vpc_peering_connection" "app_usw1_app_euc1" {
  provider    = aws.usw1
  vpc_id      = var.vpc-app_usw1[0]
  peer_vpc_id = var.vpc-app_euc1[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "app_usw1 to app_euc1 Peering"
    )
  )
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.usw2" (us-west-2)            #
##############################################
resource "aws_vpc_peering_connection_accepter" "app_usw1_app_usw2" {
  provider                  = aws.usw2
  vpc_peering_connection_id = aws_vpc_peering_connection.app_usw1_app_usw2.id
  auto_accept               = true
}
resource "aws_vpc_peering_connection" "app_usw2_app_euc1" {
  provider    = aws.usw2
  vpc_id      = var.vpc-app_usw2[0]
  peer_vpc_id = var.vpc-app_euc1[0]
  peer_region = "eu-central-1"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "app_usw2 to app_euc1 Peering"
    )
  )
}

##############################################
# Full mesh VPC peering for Application VPCs #
# Provider "aws.euc1" (eu-central-1)         #
##############################################
resource "aws_vpc_peering_connection_accepter" "app_usw1_app_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.app_usw1_app_euc1.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "app_usw2_app_euc1" {
  provider                  = aws.euc1
  vpc_peering_connection_id = aws_vpc_peering_connection.app_usw2_app_euc1.id
  auto_accept               = true
}

######################################
# Full mesh VPC peering for TFE VPCs #
# Provider "aws.usw1" (us-west-1)    #
######################################
resource "aws_vpc_peering_connection" "tfe_usw1_tfe_usw2" {
  provider    = aws.usw1
  vpc_id      = var.vpc-tfe_usw1[0]
  peer_vpc_id = var.vpc-tfe_usw2[0]
  peer_region = "us-west-2"
  auto_accept = false
  tags = merge(
    var.default_tags,
    map(
      "Name", "tfe_usw1 to tfe_usw2 Peering"
    )
  )
}
resource "aws_route" "tfe_usw1_tfe_usw2-tfe_usw1-public" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-tfe_usw1[2]
  destination_cidr_block    = var.vpc-tfe_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe_usw1_tfe_usw2.id
}
resource "aws_route" "tfe_usw1_tfe_usw2-tfe_usw1-private" {
  provider                  = aws.usw1
  route_table_id            = var.vpc-tfe_usw1[3]
  destination_cidr_block    = var.vpc-tfe_usw2[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe_usw1_tfe_usw2.id
}

######################################
# Full mesh VPC peering for TFE VPCs #
# Provider "aws.usw2" (us-west-2)    #
######################################
resource "aws_vpc_peering_connection_accepter" "tfe_usw1_tfe_usw2" {
  provider                  = aws.usw2
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe_usw1_tfe_usw2.id
  auto_accept               = true
}
resource "aws_route" "tfe_usw1_tfe_usw2-tfe_usw2-public" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-tfe_usw2[2]
  destination_cidr_block    = var.vpc-tfe_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe_usw1_tfe_usw2.id
}
resource "aws_route" "tfe_usw1_tfe_usw2-tfe_usw2-private" {
  provider                  = aws.usw2
  route_table_id            = var.vpc-tfe_usw2[3]
  destination_cidr_block    = var.vpc-tfe_usw1[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.tfe_usw1_tfe_usw2.id
}
