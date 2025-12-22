output "internal_alb_dns" {
  value = aws_lb.internal_alb.dns_name
  description = "WEB 서버 설정 파일에 넣어야 할 주소"
}

output "public_alb_dns" {
  value = aws_lb.public_alb.dns_name
  description = "Client가 접속할 DNS 주소"
}

output "public_alb_target_group_arn" {
  value = aws_lb_target_group.public_alb_target_group.arn
  description = "Web 용 Target_Group.arn"
}

output "internal_alb_target_group_arn" {
  value = aws_lb_target_group.internal_alb_target_group.arn
  description = "Was 용 Target_Group.arn"
}