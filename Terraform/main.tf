module "database" {
     source = "./database"
    providers = {
        aws = aws
        aws.tokyo = aws.tokyo
    }

    seoul_vpc_id          = module.seoul.vpc_id
    seoul_private_subnets = module.seoul.private_subnets
    seoul_db_sg_id = module.seoul.db_sg_id

    tokyo_private_subnets = module.tokyo.private_subnets
    tokyo_db_sg_id = module.tokyo.db_sg_id

    db_username     = "user01"
    db_password     = "user01password"
}

module "seoul" {
    source = "./infra"

    vpc_cidr = "10.0.0.0/16"
    public_subnet_1_cidr = "10.0.1.0/24"
    public_subnet_2_cidr = "10.0.2.0/24"
    private_subnet_1_cidr = "10.0.101.0/24"
    private_subnet_2_cidr = "10.0.102.0/24"

    key_pair = "Final-Project-Key-Seoul"
    ubuntu_ami = var.ubuntu_ami_seoul
    amazon_linux_2_ami = var.amazon_linux_2_ami_seoul
    rds_endpoint = module.database.rds_endpoint
}

module "tokyo" {
    source = "./infra"
    providers = {
        aws = aws.tokyo
    }

    vpc_cidr = "10.50.0.0/16"
    public_subnet_1_cidr = "10.50.1.0/24"
    public_subnet_2_cidr = "10.50.2.0/24"
    private_subnet_1_cidr = "10.50.101.0/24"
    private_subnet_2_cidr = "10.50.102.0/24"

    key_pair = "Final-Project-Key-Tokyo"
    ubuntu_ami = var.ubuntu_ami_tokyo
    amazon_linux_2_ami = var.amazon_linux_2_ami_tokyo
    rds_endpoint = module.database.rds_endpoint
}