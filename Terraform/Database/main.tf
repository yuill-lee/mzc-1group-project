# Database/main.tf

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = var.subnet_ids # 변수로 받음

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage   = 20
  db_name             = "mydb"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password1234"
  skip_final_snapshot = true
  backup_retention_period = 1

  # 네트워크 연결
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_sg_id] # 변수로 받음
}