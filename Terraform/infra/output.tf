output "vpc_id" {
    value = module.network.vpc_id
}
output "private_subnets" {
    value = [
        module.network.private_subnet_1_id,
        module.network.private_subnet_2_id
    ]
}

output "db_sg_id" {
    value = module.network.db_sg_id
}