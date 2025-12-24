# -------------------- Bastion Server -------------------- #
resource "aws_instance" "bastion_server" {
    instance_type = "t3.micro"
    ami = var.ubuntu_ami_seoul
    key_name = "Final-Project-Key"
    subnet_id = var.public_subnet_1_id
    vpc_security_group_ids = [var.bastion_sg_id]
    associate_public_ip_address = true

    tags = {
        Name = "Bastion-Server"
    }
}
# -------------------- Bastion Server -------------------- #
# -------------------- NAT Server -------------------- #
resource "aws_instance" "nat_server" {
    instance_type = "t3.micro"
    ami = var.amazon_linux_2_ami_seoul
    key_name = "Final-Project-Key"
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

# -------------------- WEB ALB / Target Group -------------------- #

# 1. Web Servers
resource "aws_instance" "web_1" {
    instance_type = "t3.micro"
    ami           = var.ubuntu_ami_seoul
    key_name      = "Final-Project-Key"
    
    # 1번 서버는 1번 프라이빗 서브넷에 배치
    subnet_id     = var.public_subnet_1_id  
    vpc_security_group_ids = [var.web_sg_id]
    associate_public_ip_address = true
    user_data = templatefile(
        "${path.module}/userdata/web.tpl", {
            WAS_IP = var.internal_nlb_dns
        }
    )
    tags = {
        Name = "WEB-Server-1"
    }
}

# 2. Web Servers
resource "aws_instance" "web_2" {
    instance_type = "t3.micro"
    ami           = var.ubuntu_ami_seoul
    key_name      = "Final-Project-Key"
    
    # 2번 서버는 2번 프라이빗 서브넷에 배치 (이중화)
    subnet_id     = var.public_subnet_2_id
    vpc_security_group_ids = [var.web_sg_id]
    associate_public_ip_address = true
    user_data = templatefile(
        "${path.module}/userdata/web.tpl", {
            WAS_IP = var.internal_nlb_dns
        }
    )

    tags = {
        Name = "WEB-Server-2"
    }
}

resource "aws_lb_target_group_attachment" "web_1_attachment" {
  target_group_arn = var.public_alb_target_group_arn  # ALB 타겟 그룹 주소
  target_id       = aws_instance.web_1.id       # 방금 만든 WEB 인스턴스 ID
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_2_attachment" {
  target_group_arn = var.public_alb_target_group_arn  # ALB 타겟 그룹 주소
  target_id       = aws_instance.web_2.id       # 방금 만든 WEB 인스턴스 ID
  port             = 80
}

# -------------------- WEB ALB / Target Group -------------------- #

# -------------------- WAS ALB / Target Group -------------------- #

# 1. WAS Servers
resource "aws_instance" "was_1" {
    instance_type = "t3.micro"
    ami           = var.ubuntu_ami_seoul
    key_name      = "Final-Project-Key"
    
    # 1번 WAS는 1번 프라이빗 서브넷에 배치
    subnet_id     = var.private_subnet_1_id
    vpc_security_group_ids = [var.was_sg_id]
    user_data = file("${path.module}/userdata/was.sh")

    tags = {
        Name = "WAS-Server-1"
    }
}

# 2. WAS Servers
resource "aws_instance" "was_2" {
    instance_type = "t3.micro"
    ami           = var.ubuntu_ami_seoul
    key_name      = "Final-Project-Key"
    
    # 2번 WAS는 2번 프라이빗 서브넷에 배치
    subnet_id     = var.private_subnet_2_id
    vpc_security_group_ids = [var.was_sg_id]
    user_data = file("${path.module}/userdata/was.sh")

    tags = {
        Name = "WAS-Server-2"
    }
}


resource "aws_lb_target_group_attachment" "was_1_attachment" {
  target_group_arn = var.internal_nlb_target_group_arn  # NLB 타겟 그룹 주소
  target_id       = aws_instance.was_1.id       # 방금 만든 WAS 인스턴스 ID
  port             = 9000
}

resource "aws_lb_target_group_attachment" "was_2_attachment" {
  target_group_arn = var.internal_nlb_target_group_arn  # NLB 타겟 그룹 주소
  target_id       = aws_instance.was_2.id       # 방금 만든 WAS 인스턴스 ID
  port             = 9000
}

# -------------------- WAS ALB / Target Group -------------------- #
