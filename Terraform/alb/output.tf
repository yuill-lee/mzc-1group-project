output "internal_alb_dns" {
  value = aws_lb.internal_alb.dns_name
  description = "WEB 서버 설정 파일에 넣어야 할 주소"
}