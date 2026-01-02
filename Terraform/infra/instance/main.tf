# -------------------- Bastion Server -------------------- #
resource "aws_instance" "bastion_server" {
    instance_type = "t3.micro"
    ami = var.ubuntu_ami
    key_name = var.key_pair
    subnet_id = var.public_subnet_1_id
    vpc_security_group_ids = [var.bastion_sg_id]
    associate_public_ip_address = true
    user_data = templatefile(
        "${path.module}/userdata/bastion.tpl", {
        rds_endpoint = var.rds_endpoint
    })
    tags = {
        Name = "Bastion-Server"
    }
}
# -------------------- Bastion Server -------------------- #

# -------------------- NAT Server -------------------- #
resource "aws_instance" "nat_server" {
    instance_type = "t3.micro"
    ami = var.amazon_linux_2_ami
    key_name = var.key_pair
    subnet_id = var.public_subnet_1_id
    vpc_security_group_ids = [var.nat_sg_id]
    source_dest_check = false
    associate_public_ip_address = true
    user_data = file("${path.module}/userdata/nat.sh")
    tags = {
        Name = "NAT-Server"
    }
}
# -------------------- NAT Server -------------------- #

# -------------------- WEB Launch Template -------------------- #
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template-"
  image_id      = var.ubuntu_ami
  instance_type = "t3.micro"
  key_name      = var.key_pair

  # 네트워크 설정 (보안 그룹 등)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.web_sg_id]
  }

  # 기존 web.tpl 내용을 그대로 가져옴 (Base64 인코딩 필수!)
  user_data = base64encode(templatefile(
    "${path.module}/userdata/web.tpl", {
      WAS_IP = var.internal_nlb_dns
    }
  ))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WEB-ASG-Instance" # 자동으로 찍혀 나올 서버들의 이름표
    }
  }
}
# -------------------- WEB Launch Template -------------------- #

# -------------------- WAS Launch Template -------------------- #
resource "aws_launch_template" "was_template" {
  name_prefix   = "was-template-"
  image_id      = var.ubuntu_ami
  instance_type = "t3.micro"
  key_name      = var.key_pair

  network_interfaces {
    associate_public_ip_address = false # WAS는 프라이빗이므로 Public IP X
    security_groups             = [var.was_sg_id]
  }

  # 기존 was.tpl 내용을 그대로 가져옴
  user_data = base64encode(templatefile(
    "${path.module}/userdata/was.tpl", {
      rds_endpoint = var.rds_endpoint
    }
  ))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WAS-ASG-Instance"
    }
  }
}
# -------------------- WAS Launch Template -------------------- #
# -------------------- WEB Auto Scaling Group -------------------- #
resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg-group"
  desired_capacity    = 2  # 평소에 유지할 개수 (기존 web_1, web_2 대체)
  min_size            = 2  # 최소 개수 (절대 이 밑으론 안 줄어듦)
  max_size            = 4  # 최대 개수 (트래픽 몰릴 때 늘어날 한계)

  # ★ 중요: 1번, 2번 서브넷 모두 지정 (여기에 번갈아가며 생성됨)
  vpc_zone_identifier = [var.public_subnet_1_id, var.public_subnet_2_id]

  # ★ 로드밸런서(ALB)와 연결 (기존 attachment 리소스 대체)
  target_group_arns   = [var.public_alb_target_group_arn]
  
  # 헬스 체크 설정 (ELB가 "너 아파?" 하면 바로 버리고 새로 만듦)
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WEB-ASG-Server"
    propagate_at_launch = true # 찍혀 나오는 인스턴스마다 이름표 자동 부착
  }
}
# -------------------- WEB Auto Scaling Group -------------------- #
# -------------------- WAS Auto Scaling Group -------------------- #
resource "aws_autoscaling_group" "was_asg" {
  name                = "was-asg-group"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4

  # WAS는 프라이빗 서브넷 1, 2번에 배치
  vpc_zone_identifier = [var.private_subnet_1_id, var.private_subnet_2_id]

  # ★ 로드밸런서(NLB)와 연결
  target_group_arns   = [var.internal_nlb_target_group_arn]

  # NLB는 ELB 타입 헬스체크를 100% 지원하지 않을 수 있어 EC2 타입 권장 (상황따라 다름)
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.was_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WAS-ASG-Server"
    propagate_at_launch = true
  }
}
# -------------------- WAS Auto Scaling Group -------------------- #