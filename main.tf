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
  # Variables specfic to this module
  region = ["us-west-1", "us-west-2", "eu-central-1"]  
  # Variables passed in from another module
  vpc-tfe0 = module.us-west-1.vpc-tfe
  vpc-tfe1 = module.us-west-2.vpc-tfe
  vpc-app0 = module.us-west-1.vpc-app
  vpc-app1 = module.us-west-2.vpc-app
  vpc-app2 = module.eu-central-1.vpc-app
  vpc-adm0 = module.us-west-1.vpc-adm
  vpc-adm1 = module.us-west-2.vpc-adm
  vpc-adm2 = module.eu-central-1.vpc-adm
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