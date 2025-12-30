module "network" {
    source = "./network"

    nat_instance_eni_id = module.instance.nat_instance_eni_id
}

module "instance" {
    source = "./instance"

    public_subnet_1_id = module.network.public_subnet_1_id
    public_subnet_2_id = module.network.public_subnet_2_id
    bastion_sg_id = module.network.bastion_sg_id
    nat_sg_id = module.network.nat_sg_id
    
    private_subnet_1_id = module.network.private_subnet_1_id 
    private_subnet_2_id = module.network.private_subnet_2_id
  
    web_sg_id           = module.network.web_sg_id
    was_sg_id           = module.network.was_sg_id

    internal_nlb_dns = module.alb_system.internal_nlb_dns

    public_alb_target_group_arn  = module.alb_system.public_alb_target_group_arn
    internal_nlb_target_group_arn  = module.alb_system.internal_nlb_target_group_arn

    rds_endpoint = module.database.rds_endpoint
}

module "database" {
  source = "./database"
  providers = {
    aws = aws
    aws.tokyo = aws.tokyo
  }

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  
  was_sg_id       = module.network.was_sg_id
  bastion_sg_id   = module.network.bastion_sg_id 
  db_sg_id = module.network.db_sg_id

  db_username     = "user01"
  db_password     = "user01password"
}

module "alb_system" {
  source = "./alb"

  vpc_id          = module.network.vpc_id
  public_subnets = [
    module.network.public_subnet_1_id,
    module.network.public_subnet_2_id 
  ]

  private_subnets = [
    module.network.private_subnet_1_id,
    module.network.private_subnet_2_id 
  ]

  public_alb_sg_id   = module.network.public_alb_sg_id
  internal_nlb_sg_id = module.network.internal_nlb_sg_id
}
