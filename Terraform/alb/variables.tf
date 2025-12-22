variable "vpc_id" {}
variable "public_subnets" { type = list(string) }  # Public ALB 위치
variable "private_subnets" { type = list(string) } # Internal ALB 위치
variable "public_alb_sg_id" { type = string }
variable "internal_alb_sg_id" { type = string }
variable "web_instance_ids" { type = list(string) }
variable "was_instance_ids" { type = list(string) }