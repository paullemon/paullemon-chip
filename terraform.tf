terraform {
  required_version = "0.12.6"
  required_providers {
    aws = "2.62"
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "paullemon-chip"
    workspaces {
      name = "paullemon-chip"
    }
  }
}