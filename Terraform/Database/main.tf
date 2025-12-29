resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "mzc-rds-subnet-group"
  subnet_ids = var.private_subnets 

  tags = { Name = "MZC-DB-Subnet-Group" }
}

# 보안 그룹 만들기 (WAS만 허용)
resource "aws_security_group" "db_sg" {
  name        = "mzc-db-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.was_sg_id, var.bastion_sg_id]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "MZC-DB-SG" }
}


resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  
  # PHP 코드와 일치
  db_name                = "test_db"
  username               = var.db_username
  password               = var.db_password
  
  skip_final_snapshot    = true
  multi_az               = false
  publicly_accessible    = false

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = { Name = "MZC-MySQL-DB" }
}