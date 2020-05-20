variable "region" {}

provider "aws" {
  region = var.region
}

# Password Outputs
output "console_password" {
  value = random_password.console_password.result
}
output "enc_password" {
  value = random_password.enc_password.result
}
output "tfe_initial_admin_pw" {
  value = random_password.tfe_initial_admin_pw[0].result
}
