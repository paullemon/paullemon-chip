output "vpc-tfe" {
  value = aws_vpc.vpc-tfe.id
}
output "vpc-tfe_cidr" {
  value = aws_vpc.vpc-tfe.cidr_block
}
output "vpc-app" {
  value = aws_vpc.vpc-app.id
}
output "vpc-app_cidr" {
  value = aws_vpc.vpc-app.cidr_block
}
output "vpc-adm" {
  value = aws_vpc.vpc-adm.id
}
output "vpc-adm_cidr" {
  value = aws_vpc.vpc-adm.cidr_block
}
output "sub-tfe_public" {
  value = tolist(aws_subnet.sub-tfe_public.*.id)
}
output "sub-tfe_private" {
  value = tolist(aws_subnet.sub-tfe_private.*.id)
}