module "route53" {
  source = "./route53"

  rds_endpoint = module.seoul_master.rds_endpoint_seoul_master
}

module "seoul_master" {
  source = "./seoul_master"

  db_username = var.db_username
  db_password = var.db_password
  private_subnets = var.private_subnets
  db_sg_id = var.db_sg_id
}

module "tokyo_read_replica" {
  source = "./tokyo_read_replica"
  providers = { aws = aws.tokyo }

  rds_arn_seoul_master = module.seoul_master.rds_arn_seoul_master
}