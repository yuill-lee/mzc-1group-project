module "route53" {
    source = "./route53"

    rds_endpoint = module.seoul_master.rds_endpoint_seoul_master
}

module "seoul_master" {
    source = "./seoul_master"

    db_username = var.db_username
    db_password = var.db_password

    seoul_private_subnets = var.seoul_private_subnets
    seoul_db_sg_id = var.seoul_db_sg_id
}

module "tokyo_read_replica" {
    source = "./tokyo_read_replica"
    providers = { aws = aws.tokyo }

    rds_arn_seoul_master = module.seoul_master.rds_arn_seoul_master
    tokyo_private_subnets = var.tokyo_private_subnets
    tokyo_db_sg_id = var.tokyo_db_sg_id
}