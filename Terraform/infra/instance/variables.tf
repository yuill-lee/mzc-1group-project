variable "public_subnet_1_id" { type = string }
variable "public_subnet_2_id" { type = string }
variable "bastion_sg_id" { type = string }
variable "nat_sg_id" {type = string}

variable "private_subnet_1_id" { type = string }
variable "private_subnet_2_id" { type = string }

variable "web_sg_id" { type = string }
variable "was_sg_id" { type = string }

variable "internal_nlb_dns" { type = string }

variable "public_alb_target_group_arn" { type = string }
variable "internal_nlb_target_group_arn" {  type = string }

variable "key_pair" { type = string }
variable "ubuntu_ami" { type = string }
variable "amazon_linux_2_ami" { type = string }
variable "rds_endpoint" {type = string }
