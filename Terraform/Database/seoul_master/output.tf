output "rds_endpoint_seoul_master" {
  value = aws_db_instance.rds_database_seoul_master.address
}

output "rds_arn_seoul_master"{
  value = aws_db_instance.rds_database_seoul_master.arn
}