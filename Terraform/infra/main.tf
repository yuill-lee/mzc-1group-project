module "network" {
    source = "./network"

    vpc_cidr = var.vpc_cidr
    public_subnet_1_cidr = var.public_subnet_1_cidr
    public_subnet_2_cidr = var.public_subnet_2_cidr
    private_subnet_1_cidr = var.private_subnet_1_cidr
    private_subnet_2_cidr = var.private_subnet_2_cidr
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

    internal_nlb_dns = module.lb.internal_nlb_dns

    public_alb_target_group_arn  = module.lb.public_alb_target_group_arn
    internal_nlb_target_group_arn  = module.lb.internal_nlb_target_group_arn

    key_pair = var.key_pair
    ubuntu_ami = var.ubuntu_ami
    amazon_linux_2_ami = var.amazon_linux_2_ami
    rds_endpoint = var.rds_endpoint
}



module "lb" {
    source = "./lb"

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
