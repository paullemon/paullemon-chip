module iam {
  source = "./modules/iam"
  region = "us-west-1"
}
module us-west-1 {
  source = "./modules/us-west"
  # Variables passed into this module
  default_tags = var.default_tags
  # Variables specfic to this module
  region = "us-west-1"
}
module us-west-2 {
  source = "./modules/us-west"
  # Variables passed into this module
  default_tags = var.default_tags
  # Variables specfic to this module
  region = "us-west-2"
}
module eu-central-1 {
  source = "./modules/eu-central-1"
  # Variables passed into this module
  default_tags = var.default_tags
  # Variables specfic to this module
  region = "eu-central-1"
}
module regionpeering {
  source = "./modules/regionpeering"
  # Variables passed into this module
  default_tags = var.default_tags
  # Variables passed in from another module
  vpc-adm_usw1 = [module.us-west-1.vpc-adm, module.us-west-1.vpc-adm_cidr, module.us-west-1.rtb-adm_public, module.us-west-1.rtb-adm_private]
  vpc-adm_usw2 = [module.us-west-2.vpc-adm, module.us-west-2.vpc-adm_cidr, module.us-west-2.rtb-adm_public, module.us-west-2.rtb-adm_private]
  vpc-adm_euc1 = [module.eu-central-1.vpc-adm, module.eu-central-1.vpc-adm_cidr, module.eu-central-1.rtb-adm_public, module.eu-central-1.rtb-adm_private]
  vpc-app_usw1 = [module.us-west-1.vpc-app, module.us-west-1.vpc-app_cidr, module.us-west-1.rtb-app_public, module.us-west-1.rtb-app_private]
  vpc-app_usw2 = [module.us-west-2.vpc-app, module.us-west-2.vpc-app_cidr, module.us-west-2.rtb-app_public, module.us-west-2.rtb-app_private]
  vpc-app_euc1 = [module.eu-central-1.vpc-app, module.eu-central-1.vpc-app_cidr, module.eu-central-1.rtb-app_public, module.eu-central-1.rtb-app_private]
  vpc-tfe_usw1 = [module.us-west-1.vpc-tfe, module.us-west-1.vpc-tfe_cidr, module.us-west-1.rtb-tfe_public, module.us-west-1.rtb-tfe_private]
  vpc-tfe_usw2 = [module.us-west-2.vpc-tfe, module.us-west-2.vpc-tfe_cidr, module.us-west-2.rtb-tfe_public, module.us-west-2.rtb-tfe_private]
}

##########################
## Removed from main.tf ##
##########################

#Couldnt fix the 502 errors, was told to remove and focus on the vpc scripts & using terraform cloud
#module tfe {
#  source = "./modules/tfe"
#  common_tags = var.default_tags
## Variables specific to this module
#  friendly_name_prefix = "friendly"
#  region = "us-west-1"
#  #tfe_hostname = "tfe.paullemon-exp.xyz"
#  tfe_hostname = "paullemon-exp.xyz"
#  tfe_license_file_path = "./modules/tfe/files/terraform-chip.rli"
#  instance_size = "m4.xlarge"
## Variables passed from another module
#  alb_subnet_ids = module.us-west-1.sub-tfe_public
#  ec2_subnet_ids = module.us-west-1.sub-tfe_public
#  ingress_cidr_alb_allow = ["0.0.0.0/0"]
#  ingress_cidr_ec2_allow = ["0.0.0.0/0"]
#  #ingress_cidr_ec2_allow = [module.us-west-1.vpc-tfe_cidr]
#  rds_subnet_ids = module.us-west-1.sub-tfe_private
#  tfe_initial_admin_username = var.username
#  tfe_initial_admin_pw = var.password
#  route53_hosted_zone_name = "paullemon-exp.xyz"
#  vpc_id = module.us-west-1.vpc-tfe
#}
#Havent used elastic beanstalk or wordpress before, was told to remove this and focus on the vpc scripts.
#module wordpress {
#  source = "./modules/wordpress"
## Variables passed into this module
#  default_tags = var.default_tags
#  password = var.password
#  username = var.username
## Variables specfic to this module
#  region = "us-west-1"
#}