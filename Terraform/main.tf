module "network" {
    source = "./network"

    nat-instance-eni-id = module.instance.nat-instance-eni-id
}

module "instance" {
    source = "./instance"

    public-subnet-1-id = module.network.public-subnet-1-id
    bastion-sg-id = module.network.bastion-sg-id
    nat-sg-id = module.network.nat-sg-id
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