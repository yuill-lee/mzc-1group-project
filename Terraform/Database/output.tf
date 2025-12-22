output "rds_arn" {
  value = aws_db_instance.default.arn
  description = "The ARN of the RDS instance"
}