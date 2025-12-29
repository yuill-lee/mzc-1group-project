output "rds_endpoint" {
  value = aws_db_instance.default.address
}

output "rds_arn"{
  value = aws_db_instance.default.arn
}