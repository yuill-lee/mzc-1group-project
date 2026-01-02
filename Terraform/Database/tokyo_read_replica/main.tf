terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

# DB 서브넷 그룹
resource "aws_db_subnet_group" "tokyo_db_group" {
    name       = "tokyo-db-group"
    subnet_ids = var.tokyo_private_subnets
}

#  도쿄 RDS
resource "aws_db_instance" "tokyo_db" {
    replicate_source_db    = var.rds_arn_seoul_master
    engine                 = "mysql"
    instance_class         = "db.t3.micro"
    skip_final_snapshot    = true
    
    db_subnet_group_name   = aws_db_subnet_group.tokyo_db_group.name
    vpc_security_group_ids = [var.tokyo_db_sg_id]

}