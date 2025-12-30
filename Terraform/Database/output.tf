output "rds_endpoint" {
	value = module.route53.rds_endpoint
}

output "rds_arn_seoul_master" {
	value = module.seoul_master.rds_arn_seoul_master
}