################################################
# Application VPC
################################################
output "vpc-app" {
  value = aws_vpc.vpc-app.id
}
output "vpc-app_cidr" {
  value = aws_vpc.vpc-app.cidr_block
}
output "rtb-app_public" {
  value = aws_route_table.rtb-app_public.id
}
output "rtb-app_private" {
  value = aws_default_route_table.rtb-app_private.id
}
output "sub-app_public" {
  value = tolist(aws_subnet.sub-app_public.*.id)
}
output "sub-app_private" {
  value = tolist(aws_subnet.sub-app_private.*.id)
}

################################################
# Admin VPC
################################################
output "vpc-adm" {
  value = aws_vpc.vpc-adm.id
}
output "vpc-adm_cidr" {
  value = aws_vpc.vpc-adm.cidr_block
}
output "rtb-adm_public" {
  value = aws_route_table.rtb-adm_public.id
}
output "rtb-adm_private" {
  value = aws_default_route_table.rtb-adm_private.id
}
output "sub-adm_public" {
  value = tolist(aws_subnet.sub-adm_public.*.id)
}
output "sub-adm_private" {
  value = tolist(aws_subnet.sub-adm_private.*.id)
}