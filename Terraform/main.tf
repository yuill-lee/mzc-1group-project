module "network" {
    source = "./network"

    nat-instance-eni-id = module.instance.nat-instance-eni-id
}

module "instance" {
    source = "./instance"

    public-subnet-1-id = module.network.public-subnet-1-id
    bastion-sg-id = module.network.bastion-sg-id
    nat-sg-id = module.network.nat-sg-id

    private-subnet-1-id = module.network.private_subnet_1_id 
    private-subnet-2-id = module.network.private_subnet_2_id
  
  web-sg-id           = module.network.web_sg_id
  was-sg-id           = module.network.was_sg_id
}

module "rds_database" {
  source = "./Database"

  subnet_ids = [
    module.network.private-subnet-1.id,
    module.network.private-subnet-2.id
  ]

  db_sg_id = module.network.db-sg.id
}

module "sub_region" {
  source = "./tokyo"

  providers = {
    aws = aws.tokyo
  }

  seoul_db_arn = module.rds_database.rds_arn
}

module "alb_system" {
  source = "./alb"

  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnet_ids  
  private_subnets = module.network.private_subnet_ids 

  public_alb_sg_id   = module.network.public_alb_sg_id
  internal_alb_sg_id = module.network.internal_alb_sg_id

  web_instance_ids = module.instance.web_instance_ids
  was_instance_ids = module.instance.was_instance_ids
}

output "website_url" {
  value = "http://${module.alb_system.public_alb_dns}"
}