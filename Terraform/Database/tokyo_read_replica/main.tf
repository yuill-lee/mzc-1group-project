# modules/tokyo/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
# 1. 도쿄 VPC (서울과 CIDR 겹치면 절대 안됨!)
resource "aws_vpc" "tokyo_vpc" {
  cidr_block = "10.1.0.0/16" 
  tags = { Name = "Tokyo-VPC" }
}

# 2. 도쿄 서브넷 (RDS용)
resource "aws_subnet" "tokyo_subnet_a" {
  vpc_id            = aws_vpc.tokyo_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "tokyo_subnet_c" {
  vpc_id            = aws_vpc.tokyo_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-northeast-1c"
}

# 3. DB 서브넷 그룹
resource "aws_db_subnet_group" "tokyo_db_group" {
  name       = "tokyo-db-group"
  subnet_ids = [aws_subnet.tokyo_subnet_a.id, aws_subnet.tokyo_subnet_c.id]
}

# 4. 도쿄 RDS
resource "aws_db_instance" "tokyo_db" {
  replicate_source_db    = var.rds_arn_seoul_master
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  skip_final_snapshot    = true
  
  db_subnet_group_name   = aws_db_subnet_group.tokyo_db_group.name
  # 보안그룹은 편의상 생략했으나, 실무에선 서울 VPC CIDR(10.0.0.0/16)을 허용하는 SG 필수
}