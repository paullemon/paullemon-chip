variable "region" {}

provider "aws" {
  region = var.region
}
resource "aws_route53_zone" "primary" {
  name = "paullemon-exp.xyz"
}
output "domain_name" {
  #value = join(".", ["tfe", aws_route53_zone.primary.name])
  value = aws_route53_zone.primary.name
}