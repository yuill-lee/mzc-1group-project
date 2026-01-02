# ============================================================
# 1. Public Load Balancer (User -> WEB)
# ============================================================
resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false  # 외부 공개용
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnets

  tags = { Name = "Public-ALB" }
}

resource "aws_lb_target_group" "public_alb_target_group" {
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
    target_group_arn = aws_lb_target_group.public_alb_target_group.arn
  }
}

# ============================================================
# 2. Internal Load Balancer (WEB -> WAS)
# ============================================================
resource "aws_lb" "internal_nlb" {
  name               = "Internal-NLB"
  internal           = true   # 내부 전용 (Private Subnet에 배치
  load_balancer_type = "network"
  security_groups    = [var.internal_nlb_sg_id]
  subnets            = var.private_subnets # Private Subnet 사용

  tags = { Name = "Internal-NLB" }
}

resource "aws_lb_target_group" "internal_nlb_target_group" {
  name     = "was-target-group"
  port     = 9000   
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check { 
    protocol            = "TCP"
    port                = "9000"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  } # WAS 헬스체크
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = 9000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_nlb_target_group.arn
  }
}