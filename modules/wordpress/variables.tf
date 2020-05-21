################################################
# Variables inputted from the main module
################################################
variable "default_tags" { type = map }
variable "region" {}
variable "username" {}
variable "password" {}

################################################
# Hard coded Variables
################################################
variable "as_desired" { default = 0 }
variable "as_minimum" { default = 0 }
variable "lt_ami" { default = "ami-06fcc1f0bc2c8943f" }
variable "lt_size" { default = "t3.small" }
variable "lt_volume" { default = 10 }
variable "db_size" { default = "db.m4.large" }
variable "db_volume" { default = 10 }