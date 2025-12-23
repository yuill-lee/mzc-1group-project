# ============================================================
# 1. Public Load Balancer (User -> WEB)
# ============================================================
resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false  # ★ 외부 공개용
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnets

  tags = { Name = "Public-ALB" }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check { path = "/" } # WEB 헬스체크
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# WEB 인스턴스 연결
resource "aws_lb_target_group_attachment" "web_attach" {
  count            = length(var.web_instance_ids)
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.web_instance_ids[count.index]
  port             = 80
}

# ============================================================
# 2. Internal Load Balancer (WEB -> WAS)
# ============================================================
resource "aws_lb" "internal_alb" {
  name               = "internal-alb"
  internal           = true   # ★ 내부 전용 (Private Subnet에 배치)
  load_balancer_type = "application"
  security_groups    = [var.internal_alb_sg_id]
  subnets            = var.private_subnets # ★ Private Subnet 사용

  tags = { Name = "Internal-ALB" }
}

resource "aws_lb_target_group" "was_tg" {
  name     = "was-target-group"
  port     = 8080   # ★ WAS 애플리케이션 포트 (Tomcat:8080, Node:3000 등)
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check { path = "/" } # WAS 헬스체크
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80 # ALB 자체는 80으로 받아서 뒤로 8080을 넘김
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_tg.arn
  }
}

# WAS 인스턴스 연결
resource "aws_lb_target_group_attachment" "was_attach" {
  count            = length(var.was_instance_ids)
  target_group_arn = aws_lb_target_group.was_tg.arn
  target_id        = var.was_instance_ids[count.index]
  port             = 8080 # ★ WAS 포트와 일치해야 함
}