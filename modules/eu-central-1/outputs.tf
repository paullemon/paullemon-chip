# APP VPC
output "vpc-app" {
  value = aws_vpc.vpc-app.id
}
output "vpc-app_cidr" {
  value = aws_vpc.vpc-app.cidr_block
}

# ADM VPC
output "vpc-adm" {
  value = aws_vpc.vpc-adm.id
}
output "vpc-adm_cidr" {
  value = aws_vpc.vpc-adm.cidr_block
}