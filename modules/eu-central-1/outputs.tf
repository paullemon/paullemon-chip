output "vpc-app" {
  value = aws_vpc.vpc-app.id
}
output "vpc-adm" {
  value = aws_vpc.vpc-adm.id
}
output "vpc-app_cidr" {
  value = aws_vpc.vpc-app.cidr_block
}
output "vpc-adm_cidr" {
  value = aws_vpc.vpc-adm.cidr_block
}