output "vpc_id" {
  value = aws_vpc.tokyo_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.tokyo_vpc.cidr_block
}
# 라우팅 테이블 ID도 나중에 필요하므로 미리 내보내기
output "route_table_id" {
  value = aws_vpc.tokyo_vpc.main_route_table_id 
}