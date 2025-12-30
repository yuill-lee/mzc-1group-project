variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "was_sg_id" {}
variable "bastion_sg_id" {}
variable "db_sg_id" {}
variable "db_username" {}
variable "db_password" {}