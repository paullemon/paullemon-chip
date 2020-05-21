################################################
# Global Variables
################################################
variable "default_tags" {
  type = map
  default = {
    Owner   = "paullemon-exp"
    Project = "Spacely Sprockets"
  }
}
variable "username" {
  default = "admin"
}
variable "password" {
  default = "cJ8SvEn7IarA"
}