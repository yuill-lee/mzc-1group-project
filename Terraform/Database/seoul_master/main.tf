resource "aws_db_subnet_group" "rds_subnet_group" {
    name       = "rds-subnet-group"
    subnet_ids = var.seoul_private_subnets 

    tags = { Name = "DB-Subnet-Group" }
}

resource "aws_db_instance" "rds_database_seoul_master" {
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
    vpc_security_group_ids = [var.seoul_db_sg_id]
    backup_retention_period = 7

    tags = { Name = "MZC-MySQL-DB" }
}