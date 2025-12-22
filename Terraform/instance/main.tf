# -------------------- Bastion Server -------------------- #
resource "aws_instance" "bastion-server" {
    instance_type = "t3.micro"
    ami = var.ubuntu-ami-seoul
    key_name = "Final-Project-Key"
    subnet_id = var.public-subnet-1-id
    vpc_security_group_ids = [var.bastion-sg-id]
    associate_public_ip_address = true

    tags = {
        Name = "Bastion-Server"
    }
}
# -------------------- Bastion Server -------------------- #
# -------------------- NAT Server -------------------- #
resource "aws_instance" "nat-server" {
    instance_type = "t3.micro"
    ami = var.amazon-linux-2-ami-seoul
    key_name = "Final-Project-Key"
    subnet_id = var.public-subnet-1-id
    vpc_security_group_ids = [var.nat-sg-id]
    source_dest_check = false

    tags = {
        Name = "NAT-Server"
    }
}
# -------------------- NAT Server -------------------- #

# -------------------- WEB ALB / Target Group -------------------- #

# 1. Web Servers
resource "aws_instance" "web-1" {
    instance_type = "t3.micro"
    ami           = var.amazon-linux-2-ami-seoul
    key_name      = "Final-Project-Key"
    
    # 1번 서버는 1번 프라이빗 서브넷에 배치
    subnet_id     = var.private-subnet-1-id  
    
    vpc_security_group_ids = [var.web-sg-id]

    # (선택사항) 나중에 Nginx 자동 설치 스크립트 넣을 곳
    # user_data = file("${path.module}/web_init.sh")

    tags = {
        Name = "WEB-Server-1"
    }
}

# 2. Web Servers
resource "aws_instance" "web-2" {
    instance_type = "t3.micro"
    ami           = var.amazon-linux-2-ami-seoul
    key_name      = "Final-Project-Key"
    
    # 2번 서버는 2번 프라이빗 서브넷에 배치 (이중화)
    subnet_id     = var.private-subnet-2-id
    
    vpc_security_group_ids = [var.web-sg-id]

    tags = {
        Name = "WEB-Server-2"
    }
}

# -------------------- WEB ALB / Target Group -------------------- #

# -------------------- WAS ALB / Target Group -------------------- #

# 1. WAS Servers
resource "aws_instance" "was-1" {
    instance_type = "t3.micro"
    ami           = var.amazon-linux-2-ami-seoul
    key_name      = "Final-Project-Key"
    
    # 1번 WAS는 1번 프라이빗 서브넷에 배치
    subnet_id     = var.private-subnet-1-id
    
    vpc_security_group_ids = [var.was-sg-id]

    tags = {
        Name = "WAS-Server-1"
    }
}

# 2. WAS Servers
resource "aws_instance" "was-2" {
    instance_type = "t3.micro"
    ami           = var.amazon-linux-2-ami-seoul
    key_name      = "Final-Project-Key"
    
    # 2번 WAS는 2번 프라이빗 서브넷에 배치
    subnet_id     = var.private-subnet-2-id
    
    vpc_security_group_ids = [var.was-sg-id]

    tags = {
        Name = "WAS-Server-2"
    }
}

# -------------------- WAS ALB / Target Group -------------------- #
