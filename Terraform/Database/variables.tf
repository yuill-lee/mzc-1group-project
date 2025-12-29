variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "was_sg_id" {}   # DB SG ID 대신 WAS SG ID를 받음
variable "db_username" {}
variable "db_password" {}
variable "bastion_sg_id" {}
  