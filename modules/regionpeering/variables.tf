#Variables inputted from the main module
variable "default_tags" { type = map }
variable "vpc-adm_usw1" { type = list }
variable "vpc-adm_usw2" { type = list }
variable "vpc-adm_euc1" { type = list }
variable "vpc-app_usw1" { type = list }
variable "vpc-app_usw2" { type = list }
variable "vpc-app_euc1" { type = list }
variable "vpc-tfe_usw1" { type = list }
variable "vpc-tfe_usw2" { type = list }